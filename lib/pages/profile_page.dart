import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/models/detailed_user.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/session.dart';
import 'package:smart_dripper_frontend/widgets/action_widget.dart';

class ProfilePage extends StatefulWidget { 
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<int> _selectedFile;
  Uint8List _bytesData;
  String fileName = "";
  GlobalKey _formKey = new GlobalKey();
  
  DetailedUser user;

  @override
  void initState() {
    fetchUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  _startWebFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();

      setState(() {
        fileName = file.name;        
      });

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);
    });

  }

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(',').last);
      _selectedFile = _bytesData;
    });
  }

  Future makeRequest() async {
    final token = await fetchToken();
    var url = Uri.parse('https://localhost:44354/data');
    var request = new http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromBytes('file', _selectedFile, filename: 'data'));
    request.headers.addAll(<String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    request.send().then((value) {
      if (value.statusCode == 200) {
        showDialog(
          barrierDismissible: false,
          context: context,
          child: new AlertDialog(
            title: new Text("Details"),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [
                  new Text("Upload successfull"),
                ],
              ),
            ),
            actions: [
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).translate('profile_page_title')),     
          actions: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Icon(Icons.logout),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)
                ),
                onPressed: () => {
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(AppLocalization.of(context).translate('log_out')),
                      content: Text(AppLocalization.of(context).translate('log_out_text')),
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
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
                          },
                        ),
                      ],
                    );
                  })
                },
              ),
            )
          ],   
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    AppLocalization.of(context).translate('profile_section_label'),
                    style: Theme.of(context).textTheme.headline6
                  ),
                ),              
                Text(
                  AppLocalization.of(context).translate('name') + ': ${user.name}',
                ),
                Text(
                  AppLocalization.of(context).translate('surname') + ': ${user.surname}',
                ),
                Text(
                  AppLocalization.of(context).translate('role') + ': ${user.role}',
                ),
                Divider(thickness: 0.5, color: Colors.black54,),
                Center(
                  child: Text(
                    AppLocalization.of(context).translate('action_section_label'),
                    style: Theme.of(context).textTheme.headline6
                  ),
                ),         
                Center(
                  child: SizedBox(
                    width: 600,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,        
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Data import", style: TextStyle(fontSize: 20),),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: MaterialButton(
                                          child: Text('Select file'),
                                          color: Colors.grey,
                                          onPressed: () {
                                            _startWebFilePicker();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0), 
                                        child: Text("Selected file: $fileName", style: TextStyle(fontSize: 16),)
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: MaterialButton(
                                          child: Text('Send file'),
                                          color: Colors.grey,
                                          onPressed: () {
                                            makeRequest();
                                          },
                                        ),
                                      ),
                                      Text("Data export", style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ActionWidget(AppLocalization.of(context).translate('manufacturer_label'), AppLocalization.of(context).translate('manufacturer_description'), '/manufacturers'),                
                        ActionWidget(AppLocalization.of(context).translate('diseases_label'), AppLocalization.of(context).translate('disease_description'), '/diseases'),                
                        ActionWidget(AppLocalization.of(context).translate('medical_protocols_label'), AppLocalization.of(context).translate('medical_protocol_description'), '/medicalprotocols'),                
                        ActionWidget(AppLocalization.of(context).translate('medicaments_label'), AppLocalization.of(context).translate('medicament_description'), '/medicaments'),                
                        ActionWidget(AppLocalization.of(context).translate('patients_label'), AppLocalization.of(context).translate('patient_description'), '/patients'),                
                        ActionWidget(AppLocalization.of(context).translate('users_label'), AppLocalization.of(context).translate('user_description'), '/users'),                
                        ActionWidget(AppLocalization.of(context).translate('appointments_label'), AppLocalization.of(context).translate('appointment_description'), '/appointments'),                
                        ActionWidget('Devices', 'Look and edit information about devices', '/'),                                        
                      ],
                    )
                  ),
                )
                
              ],
            ),
          ),
        ),
      );
    }
  }
}