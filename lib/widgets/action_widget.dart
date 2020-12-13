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
              //getManufacturer("157f9f06-5128-42b4-b916-94554fef15ef"),
              //createManufacturer(new ManufacturerResponse("", "Medical Company #2", "Ukraine")),
              //deleteManufacturer("310f3c22-d08c-406c-aaef-c257f6bec480"),
              //editManufacturer("157f9f06-5128-42b4-b916-94554fef15ef", new ManufacturerResponse("", "Medical Company #4", "Ukraine")),
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