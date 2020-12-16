class Doctor {
  final String name;
  final String surname;

  Doctor._(this.name, this.surname);

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return new Doctor._(
      json['name'],
      json['surname'],
    );
  }
}