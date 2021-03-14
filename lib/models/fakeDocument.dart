class FakeDocument {
  final String id;
  final Map<String, dynamic> data;
  const FakeDocument({this.id, this.data});
  dynamic operator [](String key) => data[key];
}
