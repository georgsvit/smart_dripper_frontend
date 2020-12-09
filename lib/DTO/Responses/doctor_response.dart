class DoctorResponse {
  final String token;
  final DateTime expireDate;
  final String name;
  final String surname;
  final String role;

  DoctorResponse._(this.name, this.surname, this.role, this.token, this.expireDate);

  factory DoctorResponse.fromJson(Map<String, dynamic> json) {
    return new DoctorResponse._(
      json['name'],
      json['surname'],
      json['role'],
      json['token'],
      DateTime.parse(json['expireDate'])
    );
  }
}