import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/patient_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/patient_service.dart';

class PatientFormPage extends StatefulWidget { 
  PatientResponse patient;

  PatientFormPage(this.patient);

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientFormPage> {
  final _nameTextController = TextEditingController();
  final _surnameTextController = TextEditingController();
  final _commentTextController = TextEditingController();
  
  double _formProgress = 0;
  String error = "";
  ApiStatus status;
  DateTime _selectedDate;

  @override
  void initState() {
    if (widget.patient.id != "") {
      _nameTextController.text = widget.patient.name;
      _surnameTextController.text = widget.patient.surname;
      _commentTextController.text = widget.patient.comment;
      _selectedDate = widget.patient.dob;
    } else {
      _selectedDate = DateTime.now();
      _selectedDate = _selectedDate.subtract(new Duration(days: 10000));
    }
    super.initState();
  }

  void _save() async {

    var data = new PatientResponse("", _nameTextController.text, _surnameTextController.text, _selectedDate, _commentTextController.text);

    try {
      if (widget.patient.id == "") {
        await createPatient(data).then((value) => status = value);
      } else {
        await editPatient(widget.patient.id, data).then((value) => status = value);
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
      _nameTextController,
      _commentTextController,
      _surnameTextController      
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / (controllers.length + 1);
      }
    }

    if (_selectedDate != null) {
      progress += 1 / (controllers.length + 1);

      progress = progress > 1 ? 1 : progress;
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

  Future<Null> _selectDate(BuildContext context) async {
    print(_selectedDate);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1940, 1),
        lastDate: DateTime(2020));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                child: TextFormField(
                  controller: _nameTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('name')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _surnameTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('surname')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _commentTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('comment_label')),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    AppLocalization.of(context).translate('dob') + ': ' + '${_selectedDate.toLocal()}'.split(' ')[0]
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ),
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
                  child: widget.patient.id == "" ? Text(AppLocalization.of(context).translate('create_label')) : Text(AppLocalization.of(context).translate('save_label')),
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