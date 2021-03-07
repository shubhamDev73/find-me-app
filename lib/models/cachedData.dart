import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:findme/API.dart';

Future<File> getFile (String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$filename');
}

Future<T> returnAsFuture<T> (T data) async {
  return data;
}

class CachedData<T> {

  String url;
  String cacheFile;
  String Function(T) encoder;
  T Function(String) decoder;
  Function networkDecoder;
  Function(T) setCallback;

  CachedData({this.url, this.cacheFile, this.encoder, this.networkDecoder, this.decoder, this.setCallback});

  T _cachedValue;

  Future<T> get () async {
    if(_cachedValue != null || cacheFile == null) return _cachedValue;
    try {
      File file = await getFile(cacheFile);
      String readString = await file.readAsString();
      _cachedValue = decoder != null ? decoder(readString) : readString;
    }catch(OSError) {
      _cachedValue = null;
    }
    return _cachedValue;
  }

  T getValue () {
    return _cachedValue;
  }

  Future<T> networkGet (Function(T) callback) async {
    await get();

    Future<T> future;
    if(_cachedValue == null){
      future = GETResponse<T>(url,
        decoder: networkDecoder,
        callback: (T retrievedValue) {
          _cachedValue = retrievedValue;
          if(callback != null) callback(_cachedValue);
        });
    }else{
      future = returnAsFuture<T>(_cachedValue);
      if(callback != null) callback(_cachedValue);
    }
    saveToFile();
    return future;
  }

  void set (T value) {
    _cachedValue = value;
    if(setCallback != null) setCallback(_cachedValue);
    saveToFile();
  }

  Future<void> saveToFile () async {
    if(cacheFile == null) return;
    File file = await getFile(cacheFile);
    String writeString = _cachedValue == null ? '' : encoder != null ? encoder(_cachedValue) : _cachedValue;
    await file.writeAsString(writeString);
  }

  void clear () {
    set(null);
  }

}

class MappedCachedData<K, V> extends CachedData<Map<K, V>> {

  MappedCachedData({
    String url,
    String cacheFile,
    Function networkDecoder,
    Function(Map<K, V>) setCallback,
  }) : super(
    url: url,
    cacheFile: cacheFile,
    encoder: (data) => jsonEncode(data),
    decoder: (data) => jsonDecode(data),
    networkDecoder: networkDecoder,
    setCallback: setCallback,
  );

  Future<void> mappedSet (K key, V value) async {
    if(_cachedValue == null) _cachedValue = {key: value};
    else _cachedValue[key] = value;
    if(setCallback != null) setCallback(_cachedValue);
    saveToFile();
  }

  V mappedGetValue (K key) {
    if(_cachedValue == null || !_cachedValue.containsKey(key)) return null;
    return _cachedValue[key];
  }

}
