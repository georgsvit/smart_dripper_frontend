import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/disease_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/disease_service.dart';

class DiseaseFormPage extends StatefulWidget { 
  DiseaseResponse disease;

  DiseaseFormPage(this.disease);

  @override
  _DiseaseFormState createState() => _DiseaseFormState();
}

class _DiseaseFormState extends State<DiseaseFormPage> {
  final _titleTextController = TextEditingController();
  final _symptomUkTextController = TextEditingController();
  final _symptomUaTextController = TextEditingController();
  
  double _formProgress = 0;
  String error = "";
  ApiStatus status;

  @override
  void initState() {
    if (widget.disease.id != "") {
      _titleTextController.text = widget.disease.title;
      _symptomUkTextController.text = widget.disease.symptomUk;
      _symptomUaTextController.text = widget.disease.symptomUa;
    }
    super.initState();
  }

  void _save() async {

    var data = new DiseaseResponse("", _titleTextController.text, _symptomUkTextController.text, _symptomUaTextController.text);

    try {
      if (widget.disease.id == "") {
        await createDisease(data).then((value) => status = value);
      } else {
        await editDisease(widget.disease.id, data).then((value) => status = value);
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
      _symptomUaTextController,
      _symptomUkTextController      
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
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
                  controller: _titleTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('name_title')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _symptomUkTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('symptom_uk')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _symptomUaTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('symptom_ua')),
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
                  child: widget.disease.id == "" ? Text(AppLocalization.of(context).translate('create_label')) : Text(AppLocalization.of(context).translate('save_label')),
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