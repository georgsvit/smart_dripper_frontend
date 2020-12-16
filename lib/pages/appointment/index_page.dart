import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/appointment_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/appointment_service.dart';
import 'package:smart_dripper_frontend/utils/session.dart';
import 'form_page.dart';

class AppointmentsIndexPage extends StatefulWidget { 
  @override
  _AppointmentsIndexState createState() => _AppointmentsIndexState();
}

class _AppointmentsIndexState extends State<AppointmentsIndexPage> {

  String role;
  List<AppointmentResponse> appointments;

  @override
  void initState() {
    _getElements();
    _getRole();
    super.initState();
  }

  void _getElements() {
    getAllAppointments().then((value) {
      setState(() {
        appointments = value;
      });
    });
  }

  void _getRole() async {
    fetchUser().then((value) {
      setState(() {
        role = value.role.toLowerCase();        
      });
    });
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text(''),        
      ),
    );
  }

  void _deleteElement(String id) async {
    var result;
    try {
      await deleteAppointment(id).then((value) => result = value);

      if (result == ApiStatus.success) {
        _getElements();
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showToast(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appointments == null) {
      return Center(
        child: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator()
        )
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).translate('appointments_label')),                          
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  AppLocalization.of(context).translate('appointments_list_label'),
                  style: Theme.of(context).textTheme.headline3
                ),
              ), 
              if (role == 'doctor')
              Center(
                child: RaisedButton(
                  child: Text(AppLocalization.of(context).translate('create_label')),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)
                  ),
                  onPressed: () => {
                    showDialog(context: context, builder: (BuildContext context) {                                  
                      return AppointmentFormPage(new AppointmentResponse("", "", "", "" , DateTime.now(), false, null, null, null));
                    }).then((value) => _getElements())
                  },
                ),
              ),                            
              Divider(thickness: 0.5, color: Colors.black54,),
              Center(
                child: Container(
                  height: 1100,
                  width: 500,
                  child: new ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      var element = appointments[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalization.of(context).translate('patient_label') + ': ' + element.patient.name + ' ' + element.patient.surname),
                                  Text(AppLocalization.of(context).translate('medicament_label') + ': ' + element.medicament.title),
                                  if (role == 'admin')
                                  Text(AppLocalization.of(context).translate('doctor_label') + ': ' + element.doctor.name + ' ' + element.doctor.surname),
                                  if (role == 'admin')
                                  Text(AppLocalization.of(context).translate('completed_label') + ': ' + element.isDone.toString()),
                                  Text(AppLocalization.of(context).translate('date_label') + ': ${element.date.day.toString()}/${element.date.month}/${element.date.year}'),
                                ],
                              ),
                              if (role == 'doctor')
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => {
                                  showDialog(context: context, builder: (BuildContext context) {                                  
                                    return AppointmentFormPage(element);
                                  }).then((value) => _getElements())                                  
                                },
                                hoverColor: Colors.green,
                                splashRadius: 20,
                              ),
                              if (role == 'doctor')
                              IconButton(
                                icon: Icon(Icons.delete),
                                hoverColor: Colors.red,
                                splashRadius: 20,
                                onPressed: () => {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(AppLocalization.of(context).translate('delete_label')),
                                        content: Text(AppLocalization.of(context).translate('delete_text')),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(AppLocalization.of(context).translate('no_option')),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(AppLocalization.of(context).translate('yes_option')),
                                            onPressed: () {
                                              _deleteElement(element.id);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                },                              
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ),
              ),         
            ],
          ),
        ),
      );
    }
  }
}