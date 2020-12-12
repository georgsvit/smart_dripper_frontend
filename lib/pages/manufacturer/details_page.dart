import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_dripper_frontend/dto/Responses/manufacturer_response.dart';
import 'package:smart_dripper_frontend/utils/services/manufacturer_service.dart';
import 'package:smart_dripper_frontend/widgets/list_element.dart';

class ManufacturersDetailsPage extends StatefulWidget { 
  String id;

  ManufacturersDetailsPage(this.id);

  @override
  _ManufacturersDetailsState createState() => _ManufacturersDetailsState();
}

class _ManufacturersDetailsState extends State<ManufacturersDetailsPage> {
  ManufacturerResponse manufacturer;
  
  @override
  void initState() {
    getManufacturer(widget.id).then((value) {
      setState(() {
        manufacturer = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (manufacturer == null) {
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
                  'Manufacturer information',
                  style: Theme.of(context).textTheme.headline6
                ),
              ),              
              Text(
                manufacturer.getName(),
              ),
              Text(
                manufacturer.getCountry(),
              ),
            
              Divider(thickness: 0.5, color: Colors.black54,),Divider(thickness: 0.5, color: Colors.black54,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,                  
                  children: [
                    RaisedButton(                    
                      child: Text("Edit"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
                      ),
                      onPressed: () => {},
                    ),
                    RaisedButton(                    
                      child: Text("Delete"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
                      ),
                      onPressed: () => {},
                    )
                  ],
                )
              ),         
            ],
          ),
        ),
      );
    }
  }
}