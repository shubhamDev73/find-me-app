class FakeDocument {
  final String id;
  final Map<String, dynamic> data;
  const FakeDocument({required this.id, required this.data});
  dynamic operator [](String key) => data[key];
}
