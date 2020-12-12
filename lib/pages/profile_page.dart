import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/models/detailed_user.dart';
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
          title: Text("Profile"),     
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
                      title: Text("Log Out?"),
                      content: Text("Are you really want to leave?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("Yes"),
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
                  'Profile Section',
                  style: Theme.of(context).textTheme.headline6
                ),
              ),              
              Text(
                'Name: ${user.name}',
              ),
              Text(
                'Surname: ${user.surname}',
              ),
              Text(
                'Role: ${user.role}',
              ),
              Divider(thickness: 0.5, color: Colors.black54,),
              Center(
                child: Text(
                  'Actions',
                  style: Theme.of(context).textTheme.headline6
                ),
              ),         
              ActionWidget('Manufacturer', 'Look and edit information about medicaments manufacturers', '/manufacturers'),                
              ActionWidget('Manufacturer', 'Look and edit information about medicaments manufacturers', '/'),                
              ActionWidget('Manufacturer', 'Look and edit information about medicaments manufacturers', '/'),                
              ActionWidget('Manufacturer', 'Look and edit information about medicaments manufacturers', '/'),                
            ],
          ),
        ),
      );
    }
  }
}