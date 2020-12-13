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
        body: Center(
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
              ActionWidget(AppLocalization.of(context).translate('manufacturer_label'), AppLocalization.of(context).translate('manufacturer_description'), '/manufacturers'),                
              ActionWidget(AppLocalization.of(context).translate('disease_label'), AppLocalization.of(context).translate('disease_description'), '/diseases'),                
              ActionWidget('Manufacturer', 'Look and edit information about medicaments manufacturers', '/'),                
              ActionWidget('Manufacturer', 'Look and edit information about medicaments manufacturers', '/'),                
            ],
          ),
        ),
      );
    }
  }
}