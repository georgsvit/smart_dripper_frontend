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
  final _loginTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  var token;

  String error = "";
  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [
      _loginTextController,
      _passwordTextController,
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

  void _showProfilePage() async {
    try {
      var response = await loginDoctor(_loginTextController.text, _passwordTextController.text).then((value) => value.token != "" ? token = value.token : token = "");    
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
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _loginTextController,
                  decoration: InputDecoration(hintText: 'Login'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _passwordTextController,
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
                  onPressed: _formProgress == 1 ? _showProfilePage : null,
                ),
              ),              
            ],
          ),
        ),
      )

    );
  }
}