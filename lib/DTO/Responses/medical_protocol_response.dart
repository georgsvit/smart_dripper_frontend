import 'package:smart_dripper_frontend/dto/Responses/disease_response.dart';

class MedicalProtocolResponse {
  final String id;
  final String diseaseId;
  final String title;
  final String description;
  final double maxTemp;
  final double minTemp;
  final int maxPulse;
  final int minPulse;
  final int maxBloodPressure;
  final int minBloodPressure;
  final DiseaseResponse disease;

  MedicalProtocolResponse(this.id, this.diseaseId, this.title, this.description, this.maxTemp, this.minTemp, this.maxPulse, this.minPulse, this.maxBloodPressure, this.minBloodPressure, this.disease);

  factory MedicalProtocolResponse.fromJson(Map<String, dynamic> json) {
    return new MedicalProtocolResponse(json['id'], json['diseaseId'], json['title'], json['description'], json['maxTemp'], json['minTemp'], json['maxPulse'], json['minPulse'], json['maxBloodPressure'], json['minBloodPressure'], DiseaseResponse.fromJson(json['disease']));
  }
}