import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionWidget extends StatelessWidget {

  final title;
  final description;
  final path;

  ActionWidget(this.title, this.description, this.path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 20),),
              Text(description),
            ],
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => {
              Navigator.of(context).pushNamed(path)
            },
            hoverColor: Colors.green,
            splashRadius: 20,
          )
        ],
      ),
    );
  }
}