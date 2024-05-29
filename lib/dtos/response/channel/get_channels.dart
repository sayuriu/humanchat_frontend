class IChanMeta {
  final BigInt id;
  final String name;

  IChanMeta(this.id, this.name);

  factory IChanMeta.fromJson(Map<String, dynamic> json) {
    return IChanMeta(BigInt.parse(json['id']), json['name']);
  }
}
