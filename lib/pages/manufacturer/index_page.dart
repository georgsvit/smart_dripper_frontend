import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/manufacturer_response.dart';
import 'package:smart_dripper_frontend/utils/services/manufacturer_service.dart';
import 'package:smart_dripper_frontend/widgets/list_element.dart';

class ManufacturersIndexPage extends StatefulWidget { 
  @override
  _ManufacturersIndexState createState() => _ManufacturersIndexState();
}

class _ManufacturersIndexState extends State<ManufacturersIndexPage> {

  List<ManufacturerResponse> manufacturers;

  @override
  void initState() {
    getAllManufacturers().then((value) {
      setState(() {
        manufacturers = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (manufacturers == null) {
      return Center(
        child: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator()
        )
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Manufacturers"),                          
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'List of manufacturers',
                  style: Theme.of(context).textTheme.headline3
                ),
              ),                            
              Divider(thickness: 0.5, color: Colors.black54,),
              Center(
                child: Container(
                  height: 1100,
                  width: 500,
                  child: new ListView.builder(
                    itemCount: manufacturers.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 400,
                        child: ListElementWidget(manufacturers[index].name, manufacturers[index].country, "/", manufacturers[index].id)
                      );
                    },
                  )
                ),
              ),         
            ],
          ),
        ),
      );
    }
  }
}