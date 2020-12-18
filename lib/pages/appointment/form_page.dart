import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/appointment_response.dart';
import 'package:smart_dripper_frontend/dto/Responses/medicament_response.dart';
import 'package:smart_dripper_frontend/dto/Responses/patient_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/appointment_service.dart';
import 'package:smart_dripper_frontend/utils/services/medicament_service.dart';
import 'package:smart_dripper_frontend/utils/services/patient_service.dart';
import 'package:smart_dripper_frontend/utils/session.dart';

class AppointmentFormPage extends StatefulWidget { 
  AppointmentResponse appointment;

  AppointmentFormPage(this.appointment);

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentFormPage> {
  
  double _formProgress = 0;
  String error = "";
  ApiStatus status;
  String medicamentId;
  String patientId;
  String doctorId;
  bool isDone = false;

  List<MedicamentResponse> medicaments;
  List<PatientResponse> patients;

  @override
  void initState() {
    if (widget.appointment.id != "") {
      medicamentId = widget.appointment.medicamentId;
      patientId = widget.appointment.patientId;
      doctorId = widget.appointment.doctorId;
    } else {
      _getDoctorId();
    }

    _getMedicaments();
    _getPatients();

    super.initState();
  }

  void _getDoctorId() async {
    await fetchUser().then((value) {
      setState(() {
        doctorId = value.id;
      });
    });
  }

  void _getPatients() async {
    await getAllPatients().then((value) {
      setState(() {
        patients = value;
      });
    });
  }

  void _getMedicaments() async {
    await getAllMedicaments().then((value) {
      setState(() {
        medicaments = value;
      });
    });
  }

  void _save() async {

    var data = new AppointmentResponse("", medicamentId, doctorId, patientId, DateTime.now(), isDone, null, null, null);

    try {
      if (widget.appointment.id == "") {
        await createAppointment(data).then((value) => status = value);
      } else {
        await editAppointment(widget.appointment.id, data).then((value) => status = value);
      }
      if (status != null && status == ApiStatus.success) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print(e);
      _setError(e.toString());
    }
  }

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [
      medicamentId,
      patientId,      
    ];

    for (var controller in controllers) {
      if (controller.isNotEmpty) {
        progress += 1 / (controllers.length);
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  void _setError(String e) {
    setState(() {
      error = e.replaceFirst(new RegExp(r'Exception: '), '');      
    });
  }

  @override
  Widget build(BuildContext context) {
    return patients == null || medicaments == null ? 
    Center(
        child: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator()
        )
      )
    :
    Dialog(
      child: Form(
        onChanged: _updateFormProgress,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: error != "",
                child: Text(error, style: TextStyle(color: Colors.red, fontSize: 18),),
              ),              
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(AppLocalization.of(context).translate('patient_label')),
                    DropdownButton<String>(                  
                      value: patientId,
                      items: patients.map<DropdownMenuItem<String>>((PatientResponse value) {
                        return new DropdownMenuItem<String>(
                          value: value.id,
                          child: new Text(value.name + ' ' + value.surname),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          patientId = value; 
                          _updateFormProgress();
                        });
                      },
                    ),
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(AppLocalization.of(context).translate('medicament_label')),
                    DropdownButton<String>(                  
                      value: medicamentId,
                      items: medicaments.map<DropdownMenuItem<String>>((MedicamentResponse value) {
                        return new DropdownMenuItem<String>(
                          value: value.id,
                          child: new Text(value.title),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          medicamentId = value; 
                          _updateFormProgress();
                        });
                      },
                    ),
                  ],
                )
              ),              
              Padding(
                padding: EdgeInsets.all(8),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled) ? Colors.grey[200] : Colors.green;
                    }),
                    foregroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled) ? Colors.grey : Colors.white;
                    })
                  ),
                  child: widget.appointment.id == "" ? Text(AppLocalization.of(context).translate('create_label')) : Text(AppLocalization.of(context).translate('save_label')),
                  onPressed: _formProgress == 1 ? _save : null,
                ),
              ),              
            ],
          ),
        ),
      ),
    );
  }
}