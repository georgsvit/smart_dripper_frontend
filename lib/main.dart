import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dialogs/login_dialog.dart';
import 'package:smart_dripper_frontend/pages/manufacturer/index_page.dart';
import 'package:smart_dripper_frontend/pages/medical_protocol/index_page.dart';
import 'package:smart_dripper_frontend/pages/medicament/index_page.dart';
import 'package:smart_dripper_frontend/pages/patient/index_page.dart';
import 'package:smart_dripper_frontend/pages/profile_page.dart';
import 'package:smart_dripper_frontend/pages/user/index_page.dart';
import 'package:smart_dripper_frontend/utils/app_language.dart';
import 'package:smart_dripper_frontend/utils/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'pages/disease/index_page.dart';

void main() async {
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp(this.appLanguage);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          supportedLocales: [
            Locale('en', 'EN'),
            Locale('uk', 'UA')
          ],
          locale: model.appLocal,
          localizationsDelegates: [
            AppLocalization.delegate,      
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          theme: ThemeData(primarySwatch: Colors.orange),
          routes: {
            '/': (context) => HomePage(),
            '/profile': (context) => ProfilePage(),
            '/manufacturers': (context) => ManufacturersIndexPage(),
            '/diseases': (context) => DiseasesIndexPage(),
            '/medicalprotocols': (context) => MedicalProtocolsIndexPage(),
            '/medicaments': (context) => MedicamentsIndexPage(),
            '/patients': (context) => PatientsIndexPage(),
            '/users': (context) => UsersIndexPage(),
          },        
        );
      })
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate('title')),
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text(AppLocalization.of(context).translate('sign_in')),
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
              AppLocalization.of(context).translate('main_page_title'),
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("en"));
                  },
                  child: Text('English'),
                ),
                RaisedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("uk"));
                  },
                  child: Text('Українська'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
