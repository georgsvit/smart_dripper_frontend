class ManufacturerResponse {
  final String id;
  final String name;
  final String country;

  ManufacturerResponse(this.id, this.name, this.country);

  factory ManufacturerResponse.fromJson(Map<String, dynamic> json) {
    return new ManufacturerResponse(json['id'], json['name'], json['country']);
  }

  String getName() => '$name';
  String getCountry() => '$country';
}