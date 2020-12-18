import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_dripper_frontend/dto/Responses/manufacturer_response.dart';
import 'package:smart_dripper_frontend/dto/Responses/medical_protocol_response.dart';
import 'package:smart_dripper_frontend/dto/Responses/medicament_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/manufacturer_service.dart';
import 'package:smart_dripper_frontend/utils/services/medical_protocol_service.dart';
import 'package:smart_dripper_frontend/utils/services/medicament_service.dart';

class MedicamentFormPage extends StatefulWidget { 
  MedicamentResponse medicament;

  MedicamentFormPage(this.medicament);

  @override
  _MedicamentFormState createState() => _MedicamentFormState();
}

class _MedicamentFormState extends State<MedicamentFormPage> {
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _amountTextController = TextEditingController();
  final _lackTextController = TextEditingController();
  
  double _formProgress = 0;
  String error = "";
  ApiStatus status;
  String manufacturerId;
  String medicalProtocolId;

  List<ManufacturerResponse> manufacturers;
  List<MedicalProtocolResponse> medicalProtocols;

  @override
  void initState() {
    if (widget.medicament.id != "") {
      manufacturerId = widget.medicament.manufacturerId;
      medicalProtocolId = widget.medicament.medicalProtocolId;
      _titleTextController.text = widget.medicament.title;
      _descriptionTextController.text = widget.medicament.description;
      _lackTextController.text = widget.medicament.lack.toString();
      _amountTextController.text = widget.medicament.amountInPack.toString();
    }

    _getManufacturers();
    _getMedicalProtocols();

    super.initState();
  }

  void _getManufacturers() async {
    await getAllManufacturers().then((value) {
      setState(() {
         manufacturers = value;
      });
    });
  }

  void _getMedicalProtocols() async {
    await getAllMedicalProtocols().then((value) {
      setState(() {
         medicalProtocols = value;
      });
    });
  }

  void _save() async {

    var data = new MedicamentResponse("", manufacturerId, medicalProtocolId, _titleTextController.text, _descriptionTextController.text, int.parse(_amountTextController.text), int.parse(_lackTextController.text), null, null);

    try {
      if (widget.medicament.id == "") {
        await createMedicament(data).then((value) => status = value);
      } else {
        await editMedicament(widget.medicament.id, data).then((value) => status = value);
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
      _amountTextController,
      _lackTextController
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / (controllers.length + 2);
      }
    }

    if (manufacturerId != null) {
      progress += 1.1 / (controllers.length + 2);

      progress = progress > 1 ? 1 : progress;
    }

    if (medicalProtocolId != null) {
      progress += 1 / (controllers.length + 2);

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
    return manufacturers == null || medicalProtocols == null ? 
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
                  controller: _amountTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('amount_in_pack_label')),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]+'))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _lackTextController,
                  decoration: InputDecoration(hintText: AppLocalization.of(context).translate('lack_label')),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]+'))
                  ],
                ),
              ),            
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(AppLocalization.of(context).translate('manufacturer_label')),
                    DropdownButton<String>(                  
                      value: manufacturerId,
                      items: manufacturers.map<DropdownMenuItem<String>>((ManufacturerResponse value) {
                        return new DropdownMenuItem<String>(
                          value: value.id,
                          child: new Text(value.name),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          manufacturerId = value; 
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
                    Text(AppLocalization.of(context).translate('medical_protocol_label')),
                    DropdownButton<String>(                  
                      value: medicalProtocolId,
                      items: medicalProtocols.map<DropdownMenuItem<String>>((MedicalProtocolResponse value) {
                        return new DropdownMenuItem<String>(
                          value: value.id,
                          child: new Text(value.title),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          medicalProtocolId = value; 
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
                  child: widget.medicament.id == "" ? Text(AppLocalization.of(context).translate('create_label')) : Text(AppLocalization.of(context).translate('save_label')),
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