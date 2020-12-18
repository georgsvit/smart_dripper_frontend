class AdminResponse {
  final String id;
  final String token;
  final DateTime expireDate;
  final String name;
  final String surname;
  final String role;

  AdminResponse._(this.id, this.name, this.surname, this.role, this.token, this.expireDate);

  factory AdminResponse.fromJson(Map<String, dynamic> json) {
    return new AdminResponse._(
      json['id'],
      json['name'],
      json['surname'],
      json['role'],
      json['token'],
      DateTime.parse(json['expireDate'])
    );
  }
}