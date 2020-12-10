import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/doctor_response.dart';
import 'package:smart_dripper_frontend/utils/authentication.dart';

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  AnimatedProgressIndicator({
    @required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _curveAnimation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    var colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value.withOpacity(0.4),
      ),
    );
  }
}

class _LoginDialogState extends State<LoginDialog> {
  final _doctorLoginTextController = TextEditingController();
  final _doctorPasswordTextController = TextEditingController();
  final _adminLoginTextController = TextEditingController();
  final _adminPasswordTextController = TextEditingController();


  var token;

  String error = "";
  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [
      _doctorLoginTextController,
      _doctorPasswordTextController,
      _adminLoginTextController,
      _adminPasswordTextController 
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 2 / controllers.length;
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

  void _loginDoctor() async {
    try {
      var response = await loginDoctor(_doctorLoginTextController.text, _doctorPasswordTextController.text).then((value) => value.token != "" ? token = value.token : token = "");    
      print(token);
      if (token != null) {
        Navigator.of(context).pushNamed('/profile');
      }
    } catch (e) {
      print(e);
      _setError(e.toString());
    }
  }

  void _loginAdmin() async {
    try {
      var response = await loginAdmin(_adminLoginTextController.text, _adminPasswordTextController.text).then((value) => value.token != "" ? token = value.token : token = "");    
      print(token);
      if (token != null) {
        Navigator.of(context).pushNamed('/profile');
      }
    } catch (e) {
      print(e);
      _setError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        onChanged: _updateFormProgress,
        child: SizedBox(
          width: 400,
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedProgressIndicator(value: _formProgress),
              Text('Log In', style: Theme.of(context).textTheme.headline4),
              Visibility(
                visible: error != "",
                child: Text(error, style: Theme.of(context).textTheme.headline6,),
              ),
              Container(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: TabBar(
                          tabs: [
                            Tab(
                              text: 'Doctor',
                            ),
                            Tab(
                              text: 'Admin',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 175,
                        child: TabBarView(                        
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                    controller: _doctorLoginTextController,
                                    decoration: InputDecoration(hintText: 'Login'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                    controller: _doctorPasswordTextController,
                                    decoration: InputDecoration(hintText: 'Password'),
                                    obscureText: true,
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
                                    child: Text('Log In'),
                                    onPressed: _formProgress == 1 ? _loginDoctor : null,
                                  ),
                                ),              
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                    controller: _adminLoginTextController,
                                    decoration: InputDecoration(hintText: 'Login'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                    controller: _adminPasswordTextController,
                                    decoration: InputDecoration(hintText: 'Password'),
                                    obscureText: true,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 2),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
                                        return states.contains(MaterialState.disabled) ? Colors.grey[200] : Colors.green;
                                      }),
                                      foregroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
                                        return states.contains(MaterialState.disabled) ? Colors.grey : Colors.white;
                                      })
                                    ),
                                    child: Text('Log In'),
                                    onPressed: _formProgress == 1 ? _loginAdmin : null,
                                  ),
                                ),              
                              ],
                            ),
                          ]
                        ),
                      )
                    ] 
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }
}