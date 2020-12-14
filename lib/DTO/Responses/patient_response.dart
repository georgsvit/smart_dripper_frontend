class PatientResponse {
  final String id;
  final String name;
  final String surname;
  final DateTime dob;
  final String comment;

  PatientResponse(this.id, this.name, this.surname, this.dob, this.comment);

  factory PatientResponse.fromJson(Map<String, dynamic> json) {
    return new PatientResponse(json['id'], json['name'], json['surname'], DateTime.parse(json['dob']), json['comment']);
  }
}