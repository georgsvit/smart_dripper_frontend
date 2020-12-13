import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/manufacturer_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/manufacturer_service.dart';

class ManufacturerFormPage extends StatefulWidget { 
  ManufacturerResponse manufacturer;

  ManufacturerFormPage(this.manufacturer);

  @override
  _ManufacturerFormState createState() => _ManufacturerFormState();
}

class _ManufacturerFormState extends State<ManufacturerFormPage> {
  final _nameTextController = TextEditingController();
  final _countryTextController = TextEditingController();
  
  double _formProgress = 0;
  String error = "";
  ApiStatus status;

  @override
  void initState() {
    if (widget.manufacturer.id != "") {
      _nameTextController.text = widget.manufacturer.name;
      _countryTextController.text = widget.manufacturer.country;
    }
    super.initState();
  }

  void _save() async {

    var data = new ManufacturerResponse("", _nameTextController.text, _countryTextController.text);

    try {
      if (widget.manufacturer.id == "") {
        await createManufacturer(data).then((value) => status = value);
      } else {
        await editManufacturer(widget.manufacturer.id, data).then((value) => status = value);
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
      _countryTextController,      
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
                  controller: _nameTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('name_title')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _countryTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('country')),
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
                  child: widget.manufacturer.id == "" ? Text(AppLocalization.of(context).translate('create_label')) : Text(AppLocalization.of(context).translate('save_label')),
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