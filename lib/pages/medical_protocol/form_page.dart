import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_dripper_frontend/dto/Responses/disease_response.dart';
import 'package:smart_dripper_frontend/dto/Responses/medical_protocol_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/disease_service.dart';
import 'package:smart_dripper_frontend/utils/services/medical_protocol_service.dart';

class MedicalProtocolFormPage extends StatefulWidget { 
  MedicalProtocolResponse medicalprotocol;

  MedicalProtocolFormPage(this.medicalprotocol);

  @override
  _MedicalProtocolFormState createState() => _MedicalProtocolFormState();
}

class _MedicalProtocolFormState extends State<MedicalProtocolFormPage> {
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _maxTempTextController = TextEditingController();
  final _minTempTextController = TextEditingController();
  final _maxPulseTextController = TextEditingController();
  final _minPulseTextController = TextEditingController();
  final _maxBPTextController = TextEditingController();
  final _minBPTextController = TextEditingController();
  
  double _formProgress = 0;
  String error = "";
  ApiStatus status;
  String diseaseId;
  DiseaseResponse disease;

  List<DiseaseResponse> diseases;

  @override
  void initState() {
    if (widget.medicalprotocol.id != "") {
      disease = widget.medicalprotocol.disease;
      diseaseId = disease.id;
      _titleTextController.text = widget.medicalprotocol.title;
      _descriptionTextController.text = widget.medicalprotocol.description;
      _maxTempTextController.text = widget.medicalprotocol.maxTemp.toString();
      _minTempTextController.text = widget.medicalprotocol.minTemp.toString();
      _maxPulseTextController.text = widget.medicalprotocol.maxPulse.toString();
      _minPulseTextController.text = widget.medicalprotocol.minPulse.toString();
      _maxBPTextController.text = widget.medicalprotocol.maxBloodPressure.toString();
      _minBPTextController.text = widget.medicalprotocol.minBloodPressure.toString();
    }

    _getDiseases();

    super.initState();
  }

  void _getDiseases() async {
    await getAllDiseases().then((value) {
      setState(() {
         diseases = value;
      });
    });
  }

  void _save() async {

    var data = new MedicalProtocolResponse("", diseaseId, _titleTextController.text, _descriptionTextController.text, double.parse(_maxTempTextController.text), double.parse(_minTempTextController.text), int.parse(_maxPulseTextController.text), int.parse(_minPulseTextController.text), int.parse(_maxBPTextController.text), int.parse(_minBPTextController.text), null);

    try {
      if (widget.medicalprotocol.id == "") {
        await createMedicalProtocol(data).then((value) => status = value);
      } else {
        await editMedicalProtocol(widget.medicalprotocol.id, data).then((value) => status = value);
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
      _titleTextController,
      _descriptionTextController,
      _maxTempTextController,
      _minTempTextController,
      _maxPulseTextController,
      _minPulseTextController,
      _maxBPTextController,
      _minBPTextController 
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / (controllers.length + 1);
      }
    }

    if (diseaseId != null) {
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

  @override
  Widget build(BuildContext context) {
    return diseases == null ? 
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
                child: TextFormField(
                  controller: _titleTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('name_title')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _descriptionTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('description_label')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _maxTempTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('max_temp')),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _minTempTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('min_temp')),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _maxPulseTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('max_pulse')),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _minPulseTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('min_pulse')),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _maxBPTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('max_bp')),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _minBPTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('min_bp')),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(AppLocalization.of(context).translate('disease_label')),
                    DropdownButton<String>(                  
                      value: diseaseId,
                      items: diseases.map<DropdownMenuItem<String>>((DiseaseResponse value) {
                        return new DropdownMenuItem<String>(
                          value: value.id,
                          child: new Text(value.title),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          diseaseId = value; 
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
                  child: widget.medicalprotocol.id == "" ? Text(AppLocalization.of(context).translate('create_label')) : Text(AppLocalization.of(context).translate('save_label')),
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