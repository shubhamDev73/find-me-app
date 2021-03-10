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

  T emptyValue;
  String url;
  String cacheFile;
  String Function(T) encoder;
  T Function(String) decoder;
  Function networkDecoder;
  Function setCallback;

  CachedData({this.emptyValue, this.url, this.cacheFile, this.encoder, this.networkDecoder, this.decoder, this.setCallback});

  T _cachedValue;

  Future<T> get () async {
    // memory value
    if(_cachedValue == null) _cachedValue = emptyValue;
    if(_cachedValue != emptyValue) return _cachedValue;

    // reading from file
    if(cacheFile != null)
      try {
        File file = await getFile(cacheFile);
        String readString = await file.readAsString();
        _cachedValue = readString == '' || readString == null ? emptyValue : decoder?.call(readString) ?? readString;
      } catch (OSError) {
        _cachedValue = emptyValue;
      }
    if(_cachedValue != emptyValue || url == null) return _cachedValue;

    // network call
    return GETResponse<T>(url,
        decoder: networkDecoder,
        callback: (T retrievedValue) => set(retrievedValue),
    );

  }

  void set (T value) {
    _cachedValue = value;
    setCallback?.call(_cachedValue);
    saveToFile();
  }

  void update (T Function(T) function) {
    set(function(_cachedValue));
  }

  void clear () {
    set(emptyValue);
  }

  Future<void> saveToFile () async {
    if(cacheFile == null) return;
    File file = await getFile(cacheFile);
    String writeString = _cachedValue == emptyValue ? '' : encoder?.call(_cachedValue) ?? _cachedValue;
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
    emptyValue: {},
    url: url,
    cacheFile: cacheFile,
    encoder: (data) => jsonEncode(data),
    decoder: (data) => Map<K, V>.from(jsonDecode(data)),
    networkDecoder: networkDecoder,
    setCallback: setCallback,
  );

  Future<void> mappedSet (K key, V value) async {
    _cachedValue[key] = value;
    setCallback?.call(_cachedValue, key);
    saveToFile();
  }

  V mappedGetValue (K key) {
    if(!_cachedValue.containsKey(key)) return null;
    return _cachedValue[key];
  }

}
