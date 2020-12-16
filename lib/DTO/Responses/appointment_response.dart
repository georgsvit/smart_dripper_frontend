import 'package:smart_dripper_frontend/dto/Responses/medicament_response.dart';
import 'package:smart_dripper_frontend/dto/Responses/patient_response.dart';
import 'package:smart_dripper_frontend/models/doctor.dart';

class AppointmentResponse {
  final String id;
  final String medicamentId;
  final String doctorId;
  final String patientId;
  final DateTime date;
  final bool isDone;
  final MedicamentResponse medicament;
  final Doctor doctor;
  final PatientResponse patient;

  AppointmentResponse(this.id, this.medicamentId, this.doctorId, this.patientId, this.date, this.isDone, this.medicament, this.doctor, this.patient);

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return new AppointmentResponse(json['id'], json['medicamentId'], json['doctorId'], json['patientId'], DateTime.parse(json['date']), json['isDone'], MedicamentResponse.fromJsonSimplified(json['medicament']), Doctor.fromJson(json['doctor']), PatientResponse.fromJsonSimplified(json['patient']));
  }
}