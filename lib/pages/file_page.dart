import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';

class FilePage extends StatefulWidget { 
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            
          ],
        ),
      ),
    );
  }
}