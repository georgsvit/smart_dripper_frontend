import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/manufacturer_response.dart';
import 'package:smart_dripper_frontend/utils/services/manufacturer_service.dart';

class ActionWidget extends StatelessWidget {

  final title;
  final description;
  final path;

  ActionWidget(this.title, this.description, this.path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ),
      ),
    );
  }
}