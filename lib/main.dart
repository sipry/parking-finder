import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_parking_finder_app/services/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_launcher/maps_launcher.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData.dark(),
        home: HomePage(),
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  Location _location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/mona-eendra-vC8wj_Kphak-unsplash.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null
                  ? SizedBox()
                  : CircleAvatar(
                      backgroundImage: FileImage(_image),
                      radius: 100,
                    ),
              SizedBox(
                height: 50,
              ),
              _location == null
                  ? RaisedButton(
                      color: Color(0xFFEFEFEF),
                      child: Text('Save Location'),
                      textColor: Colors.black,
                      onPressed: () => getCurrentLocation(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              color: Color(0xFFEFEFEF),
                              child: Text("Find you'r spot"),
                              textColor: Colors.black,
                              onPressed: () {
                                MapsLauncher.launchCoordinates(
                                    _location.latitude, _location.longitude);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ],
                        ),
                        ButtonTheme(
                          child: RaisedButton(
                            color: Color(0xFFEFEFEF),
                            child: Text('New Location'),
                            textColor: Colors.black,
                            onPressed: () {
                              setState(() {
                                _image = null;
                                _location = null;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: Color(0xFFEFEFEF),
        tooltip: 'Pick Image',
        child: Icon(
          Icons.add_a_photo,
          color: Colors.black,
        ),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future<dynamic> getCurrentLocation() async {
    _location = Location();
    await _location.setLocation();
    setState(() {});
  }
}
