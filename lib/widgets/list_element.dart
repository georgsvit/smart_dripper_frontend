import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/pages/manufacturer/details_page.dart';

class ListElementWidget extends StatelessWidget {

  final title;
  final description;
  final path;
  final id;

  ListElementWidget(this.title, this.description, this.path, this.id);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
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

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManufacturersDetailsPage(id)))
              },
              hoverColor: Colors.green,
              splashRadius: 20,
            )
          ],
        ),
      ),
    );
  }
}