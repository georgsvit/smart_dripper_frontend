import 'package:smart_dripper_frontend/dto/Responses/medical_protocol_response.dart';
import 'manufacturer_response.dart';

class MedicamentResponse {
  final String id;
  final String manufacturerId;
  final String medicalProtocolId;
  final String title;
  final String description;
  final int amountInPack;
  final int lack;
  final ManufacturerResponse manufacturer;
  final MedicalProtocolResponse medicalProtocol;

  MedicamentResponse(this.id, this.manufacturerId, this.medicalProtocolId, this.title, this.description, this.amountInPack, this.lack, this.manufacturer, this.medicalProtocol);

  factory MedicamentResponse.fromJson(Map<String, dynamic> json) {
    return new MedicamentResponse(json['id'], json['manufacturerId'], json['medicalProtocolId'], json['title'], json['description'], json['amountInPack'], json['lack'], ManufacturerResponse.fromJson(json['manufacturer']), MedicalProtocolResponse.fromJsonSimplified(json['medicalProtocol']));
  }
}