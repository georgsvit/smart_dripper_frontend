import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/medical_protocol_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/medical_protocol_service.dart';

import 'form_page.dart';

class MedicalProtocolsIndexPage extends StatefulWidget { 
  @override
  _MedicalProtocolsIndexState createState() => _MedicalProtocolsIndexState();
}

class _MedicalProtocolsIndexState extends State<MedicalProtocolsIndexPage> {

  List<MedicalProtocolResponse> medicalprotocols;

  @override
  void initState() {
    _getElements();
    super.initState();
  }

  void _getElements() {
    getAllMedicalProtocols().then((value) {
      setState(() {
        medicalprotocols = value;
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
      await deleteMedicalProtocol(id).then((value) => result = value);

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
    if (medicalprotocols == null) {
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
          title: Text(AppLocalization.of(context).translate('medical_protocols_label')),                          
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  AppLocalization.of(context).translate('medical_protocols_list_label'),
                  style: Theme.of(context).textTheme.headline3
                ),
              ), 
              Center(
                child: RaisedButton(
                  child: Text(AppLocalization.of(context).translate('create_label')),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)
                  ),
                  onPressed: () => {
                    showDialog(context: context, builder: (BuildContext context) {                                  
                      return MedicalProtocolFormPage(new MedicalProtocolResponse("", "", "", "" , 0, 0, 0, 0, 0, 0, null));
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
                    itemCount: medicalprotocols.length,
                    itemBuilder: (context, index) {
                      var element = medicalprotocols[index];
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
                                  Text(AppLocalization.of(context).translate('name_title') + ': ' + element.title, style: TextStyle(fontSize: 20),),
                                  Text(AppLocalization.of(context).translate('description_label') + ': ' + element.description),
                                  Text(AppLocalization.of(context).translate('max_temp') + ': ' + element.maxTemp.toString() + ' ℃'),
                                  Text(AppLocalization.of(context).translate('min_temp') + ': ' + element.minTemp.toString() + ' ℃'),
                                  Text(AppLocalization.of(context).translate('max_pulse') + ': ' + element.maxPulse.toString() + ' ' + AppLocalization.of(context).translate('pulse_measurement_label')),
                                  Text(AppLocalization.of(context).translate('min_pulse') + ': ' + element.minPulse.toString() + ' ' + AppLocalization.of(context).translate('pulse_measurement_label')),
                                  Text(AppLocalization.of(context).translate('max_bp') + ': ' + element.maxBloodPressure.toString() + ' ' + AppLocalization.of(context).translate('bp_measurement_label')),
                                  Text(AppLocalization.of(context).translate('min_bp') + ': ' + element.minBloodPressure.toString() + ' ' + AppLocalization.of(context).translate('bp_measurement_label')),
                                  Text(AppLocalization.of(context).translate('disease_label') + ': ' + element.disease.title),                                  
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => {
                                  showDialog(context: context, builder: (BuildContext context) {                                  
                                    return MedicalProtocolFormPage(element);
                                  }).then((value) => _getElements())                                  
                                },
                                hoverColor: Colors.green,
                                splashRadius: 20,
                              ),
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