import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/user_response.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:smart_dripper_frontend/utils/services/user_service.dart';

class UserFormPage extends StatefulWidget { 
  UserResponse user;

  UserFormPage(this.user);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserFormPage> {
  final _nameTextController = TextEditingController();
  final _surnameTextController = TextEditingController();
  final _loginTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  
  double _formProgress = 0;
  String error = "";
  ApiStatus status;
  String role;

  @override
  void initState() {
    if (widget.user.id != "") {
      role = widget.user.role.toLowerCase();
      _nameTextController.text = widget.user.name;
      _surnameTextController.text = widget.user.surname;
      _loginTextController.text = widget.user.login;
      _passwordTextController.text = widget.user.password;
    }
    super.initState();
  }

  void _save() async {

    var data = new UserResponse("", _nameTextController.text, _surnameTextController.text, "", _loginTextController.text, _passwordTextController.text);

    try {
      if (widget.user.id == "") {
        await createUser(data, role).then((value) => status = value);
      } else {
        await editUser(widget.user.id, data, role).then((value) => status = value);
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
      _surnameTextController,
      _loginTextController,
      _passwordTextController
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        if (widget.user.id == "") {
          progress += 1 / controllers.length;
        } else {
          progress += 1 / (controllers.length - 2);
        }
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

  void _setRole(String value) {
    setState(() {
      role = value;      
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
                child: Column(
                  children: [
                    new Divider(height: 5.0, color: Colors.black),
                    Text(AppLocalization.of(context).translate('role') + ':'),
                    Row(
                      children: [
                        Radio(
                          value: 'DOCTOR',
                          groupValue: role,
                          onChanged: _setRole,
                        ),
                        Text(AppLocalization.of(context).translate('doctor_label')),
                        Radio(
                          value: 'NURSE',
                          groupValue: role,
                          onChanged: _setRole,
                        ),
                        Text(AppLocalization.of(context).translate('nurse_label')),
                      ],
                    ),
                    new Divider(height: 5.0, color: Colors.black),
                  ],
                ),
              ),

              if (widget.user.id == "") 
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _loginTextController,
                    decoration: InputDecoration(hintText: AppLocalization.of(context).translate('login')),
                  ),
                ),
              if (widget.user.id == "")
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _passwordTextController,
                    decoration: InputDecoration(hintText: AppLocalization.of(context).translate('password')),
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
                  child: widget.user.id == "" ? Text(AppLocalization.of(context).translate('create_label')) : Text(AppLocalization.of(context).translate('save_label')),
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