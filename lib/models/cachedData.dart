import 'dart:collection';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:findme/API.dart';

Future<File> getFile (String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$filename');
}

class CachedData<T> {

  T emptyValue;
  String? url;
  String? cacheFile;
  String Function(T)? encoder;
  T Function(String)? decoder;
  T Function(String)? networkDecoder;
  Function? setCallback;

  CachedData({required this.emptyValue, this.url, this.cacheFile, this.encoder, this.networkDecoder, this.decoder, this.setCallback});

  T? _cachedValue;

  Future<T> get ({bool forceNetwork = false}) async {
    // memory value
    if(_cachedValue == null) _cachedValue = emptyValue;

    if(!forceNetwork){
      if(!isEmpty()) return _cachedValue!;

      // reading from file
      if(cacheFile != null)
        try{
          File file = await getFile(cacheFile!);
          String readString = await file.readAsString();
          _cachedValue = readString == '' ? emptyValue : (decoder?.call(readString) ?? jsonDecode(readString));
        }catch(e){
          _cachedValue = emptyValue;
        }
      if(!isEmpty() || url == null) return _cachedValue!;
    }

    // network call
    return GETResponse<T>(url!,
      decoder: networkDecoder ?? decoder ?? (data) => jsonDecode(data),
      callback: (T retrievedValue) => set(retrievedValue),
    );

  }

  void set (T value) {
    _cachedValue = value;
    setCallback?.call(_cachedValue);
    saveToFile();
  }

  void update (T Function(T) function) {
    set(function(_cachedValue!));
  }

  void clear () {
    set(emptyValue);
  }

  bool isEmpty () {
    if(_cachedValue is List) return (_cachedValue as List).isEmpty;
    return _cachedValue == emptyValue;
  }

  Future<void> saveToFile () async {
    if(cacheFile == null) return;
    File file = await getFile(cacheFile!);
    String writeString = isEmpty() ? '' : (encoder?.call(_cachedValue!) ?? jsonEncode(_cachedValue));
    await file.writeAsString(writeString);
  }

}

class MappedCachedData<K, V> extends CachedData<LinkedHashMap<K, V>> {

  MappedCachedData({
    String? url,
    String? cacheFile,
    String Function(LinkedHashMap<K, V>)? encoder,
    LinkedHashMap<K, V> Function(String)? decoder,
    LinkedHashMap<K, V> Function(String)? networkDecoder,
    Function(LinkedHashMap<K, V>, K key)? setCallback,
  }) : super(
    emptyValue: new LinkedHashMap<K, V>(),
    url: url,
    cacheFile: cacheFile,
    encoder: encoder,
    decoder: decoder ?? (data) => LinkedHashMap<K, V>.from(jsonDecode(data)),
    networkDecoder: networkDecoder,
    setCallback: setCallback,
  );

  @override
  bool isEmpty () {
    return _cachedValue == null || _cachedValue!.isEmpty;
  }

  @override
  void clear () {
    emptyValue = new LinkedHashMap<K, V>();
    super.clear();
  }

  void mappedSet (K key, V value) {
    _cachedValue![key] = value;
    setCallback?.call(_cachedValue, key);
    saveToFile();
  }

  void mappedUpdate (K key, V Function(V) function) {
    mappedSet(key, function(_cachedValue![key]!));
  }

}
