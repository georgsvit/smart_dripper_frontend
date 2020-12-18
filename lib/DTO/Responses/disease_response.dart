import 'package:smart_dripper_frontend/utils/session.dart';

class DiseaseResponse {
  final String id;
  final String title;
  final String symptomUk;
  final String symptomUa;

  DiseaseResponse(this.id, this.title, this.symptomUk, this.symptomUa);

  factory DiseaseResponse.fromJson(Map<String, dynamic> json) {
    return new DiseaseResponse(json['id'], json['title'], json['symptomUk'], json['symptomUa']);
  }

  String getSymptom() {
    return (fetchLocaleAsString() == 'ua') ? symptomUa : symptomUk;
  }
}