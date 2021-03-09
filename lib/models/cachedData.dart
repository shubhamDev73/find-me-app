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
  Function setCallback;

  CachedData({this.url, this.cacheFile, this.encoder, this.networkDecoder, this.decoder, this.setCallback});

  T _cachedValue;

  Future<T> get () async {
    // memory value
    if(_cachedValue != null) return _cachedValue;

    // reading from file
    if(cacheFile != null)
      try {
        File file = await getFile(cacheFile);
        String readString = await file.readAsString();
        _cachedValue = decoder != null ? decoder(readString) : readString;
      }catch(OSError) {
        _cachedValue = null;
      }
    if(_cachedValue != null || url == null) return _cachedValue;

    // network call
    return GETResponse<T>(url,
        decoder: networkDecoder,
        callback: (T retrievedValue) => set(retrievedValue),
    );

  }

  void set (T value) {
    _cachedValue = value;
    if(setCallback != null) setCallback(_cachedValue);
    saveToFile();
  }

  void update (T Function(T) function) {
    set(function(_cachedValue));
  }

  void clear () {
    set(null);
  }

  Future<void> saveToFile () async {
    if(cacheFile == null) return;
    File file = await getFile(cacheFile);
    String writeString = _cachedValue == null ? '' : encoder != null ? encoder(_cachedValue) : _cachedValue;
    await file.writeAsString(writeString);
  }

}

class MappedCachedData<K, V> extends CachedData<Map<K, V>> {

  MappedCachedData({
    String url,
    String cacheFile,
    Function networkDecoder,
    Function(Map<K, V>, K key) setCallback,
  }) : super(
    url: url,
    cacheFile: cacheFile,
    encoder: (data) => jsonEncode(data),
    decoder: (data) => Map<K, V>.from(jsonDecode(data)),
    networkDecoder: networkDecoder,
    setCallback: setCallback,
  );

  Future<void> mappedSet (K key, V value) async {
    if(_cachedValue == null) _cachedValue = {key: value};
    else _cachedValue[key] = value;
    if(setCallback != null) setCallback(_cachedValue, key);
    saveToFile();
  }

  V mappedGetValue (K key) {
    if(_cachedValue == null || !_cachedValue.containsKey(key)) return null;
    return _cachedValue[key];
  }

}
