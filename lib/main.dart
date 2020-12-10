import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dialogs/login_dialog.dart';
import 'package:smart_dripper_frontend/pages/profile_page.dart';
import 'package:smart_dripper_frontend/utils/authentication.dart';

//import 'login/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.orange),
        routes: {
          '/': (context) => HomePage(),
          '/profile': (context) => ProfilePage()
        },
        //LoginScreen()
        //MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text("Sing In"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)
              ),
              onPressed: () => {
                showDialog(context: context, builder: (BuildContext context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    height: height - 400,
                    width: width - 400,
                    child: LoginDialog(),
                  );
                  //return ;
                })
              },
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Main page',
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            ),
          ],
        ),
      ),
    );
  }
}
