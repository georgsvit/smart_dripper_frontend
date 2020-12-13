import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/disease_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/disease_service.dart';

import 'form_page.dart';

class DiseasesIndexPage extends StatefulWidget { 
  @override
  _DiseasesIndexState createState() => _DiseasesIndexState();
}

class _DiseasesIndexState extends State<DiseasesIndexPage> {

  List<DiseaseResponse> diseases;

  @override
  void initState() {
    _getElements();
    super.initState();
  }

  void _getElements() {
    getAllDiseases().then((value) {
      setState(() {
        diseases = value;
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
      await deleteDisease(id).then((value) => result = value);

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
    if (diseases == null) {
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
          title: Text(AppLocalization.of(context).translate('disease_label')),                          
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  AppLocalization.of(context).translate('diseases_list_label'),
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
                      return DiseaseFormPage(new DiseaseResponse("", "", "", ""));
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
                    itemCount: diseases.length,
                    itemBuilder: (context, index) {
                      var element = diseases[index];
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
                                  Text(AppLocalization.of(context).translate('symptom_ua') + ': ' + element.symptomUa),
                                  Text(AppLocalization.of(context).translate('symptom_uk') + ': ' + element.symptomUk),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => {
                                  showDialog(context: context, builder: (BuildContext context) {                                  
                                    return DiseaseFormPage(element);
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