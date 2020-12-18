class DoctorResponse {
  final String id;
  final String token;
  final DateTime expireDate;
  final String name;
  final String surname;
  final String role;

  DoctorResponse._(this.id, this.name, this.surname, this.role, this.token, this.expireDate);

  factory DoctorResponse.fromJson(Map<String, dynamic> json) {
    return new DoctorResponse._(
      json['id'],
      json['name'],
      json['surname'],
      json['role'],
      json['token'],
      DateTime.parse(json['expireDate'])
    );
  }
}