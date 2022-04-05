import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/pocetna/PocetnaStrana.dart';
import 'package:moj_grad/podesavanja/ApiPromenaPodataka.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromeniPodatke extends StatefulWidget {
  @override
  _PromenaPodatakaState createState() => _PromenaPodatakaState();
}

class _PromenaPodatakaState extends State<PromeniPodatke>
    with TickerProviderStateMixin {
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _bio = new TextEditingController();

  String token = '';
  File _image;
  bool imageEnabled = true;
  bool usernameEnabled = true;
  bool bioEnabled = true;
  String oldBio = "";
  String oldUsername = "";
  String get getIme => _username.text;
  String get getBio => _bio.text;

  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

_focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.value=0;
      }
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 80.0, end: 370.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    SharedPreferences p = await SharedPreferences.getInstance();
    data['username'] = p.getString("username");
    data['image'] = p.getString("image");
    data['bio'] = p.getString("bio");
    data['token'] = p.getString("token");
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: CircularProgressIndicator(),
                );
              } else {
                token = snapshot.data['token'];
                _username.text = snapshot.data['username'];
                oldUsername = snapshot.data['username'];
                _bio.text = snapshot.data['username'] != null
                    ? snapshot.data['bio']
                    : "";
                oldBio = _bio.text;
                return Scaffold(
                    resizeToAvoidBottomPadding: false,
                    appBar: AppBar(
                      title: Text("Promena podataka"),
                    ),
                    body: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              
                              GestureDetector(
                                child: Container(
                                    //slika korisnika
                                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                    alignment: Alignment.center,
                                    child:
                                        /*CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _image==null? NetworkImage(snapshot.data['image']):FileImage(_image),
                                ),*/
                                        Stack(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage: _image == null
                                              ? NetworkImage(
                                                  snapshot.data['image'])
                                              : FileImage(_image),
                                        ),
                                        Positioned(
                                          right: -3,
                                          top: 0,
                                          child: Icon(
                                            Icons.edit,
                                            size: 30,
                                          ),
                                        )
                                      ],
                                    )),
                                onTap: () {
                                  _showChoiceDialog(context);
                                },
                              ),
                              _image != null
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: 10.0, bottom: 5.0),
                                      child: FlatButton(
                                        onPressed: imageEnabled == true
                                            ? () {
                                                promeniSliku(_image);
                                              }
                                            : null,
                                        color: Theme.of(context).accentColor,
                                        padding: EdgeInsets.all(3.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                            Text("Potvrdi",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                      ))
                                  : Container(),
                              Card(
                                //pozadina dela za menjanje sa borderradius
                                elevation: 8.0,
                                margin:
                                    EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                                
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                      Container(
                                          //korisnicko ime tekst
                                          margin: EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            "Korisničko ime",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 2,
                                            ),
                                          )),
                                      TextField(
                                          //polje za novo ime
                                          textAlign: TextAlign.center,
                                          maxLength: 20,
                                          controller: _username,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                          )),
                                    
                                      Container(
                                          //bio tekst
                                          margin: EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            "Vaša biografija",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 2,
                                            ),
                                          )),
                                          
                                      TextField(
                                          //polje za novi bio
                                          focusNode: _focusNode,
                                          textAlign: TextAlign.center,
                                          controller: _bio,
                                          maxLength: 255,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                          )
                                          
                                          ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, bottom: 5.0),
                                          child: FlatButton(
                                            onPressed: bioEnabled
                                                ? () {
                                                    potvrdi();
                                                  }
                                                : null,
                                            color:
                                                Theme.of(context).accentColor,
                                            padding: EdgeInsets.all(3.0),
                                            child: Column(
                                              // Replace with a Row for horizontal icon + text
                                              children: <Widget>[
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                                Text("Potvrdi",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )),
                                                    
                                              ],
                                            ),
                                          )),
                                          
                                   ])),
                              ),
                            SizedBox(height: _animation.value), ])));
              }
            }));
  }

  void _dialog(context, String text) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Uspešno ste promenili " + text),
          );
        });
  }

  void _falseDialog(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Greška"),
            content: Text("Pokušajte ponovo"),
          );
        });
  }

  void potvrdi()async {
    setState(() {
      bioEnabled = false;
    });
    if(oldBio!=_bio.text && oldUsername!=_username.text){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
      var rezultatBio = await ApiPromenaPodataka.promeniBio(token, this.getBio);
      var rezultatUser = await ApiPromenaPodataka.promeniIme(token, this.getIme);
      Navigator.pop(context);
      if(rezultatUser==true && rezultatBio==true){
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/PocetnaStrana', (Route<dynamic> route) => false);
      _dialog(context, "podatke.");
      }
      else if(rezultatUser==false && rezultatBio==true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PromeniPodatke()));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content:
                  Text("Korisničko ime je zauzeto. Izaberite drugo"),
            );
          });
      }
      else if(rezultatUser==true && rezultatBio==false){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PromeniPodatke()));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content:
                  Text("Biografija nije promenjena. pokušajte ponovo"),
            );
          });
      }
      else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PocetnaStrana()));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content:
                  Text("Biografija nije promenjena. pokušajte ponovo"),
            );
          });
      }
    }
    else if(oldUsername!=_username.text && oldBio==_bio.text){
      promeniIme(_username.text);
    }
    else if(oldUsername==_username.text && oldBio!=_bio.text){
      promeniBio(_bio.text);
    }
  }

  void promeniBio(String bio) async {
    setState(() {
      bioEnabled = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
    var rezultat = await ApiPromenaPodataka.promeniBio(token, this.getBio);
    Navigator.pop(context);
    print(token);
    //print(snapshot.data['bio']);
    print(bio);
    if (rezultat == true) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/PocetnaStrana', (Route<dynamic> route) => false);
      _dialog(context, "biografiju.");
    } else {
      setState(() {
        bioEnabled = true;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content:
                  Text("Došlo je do greške. Kontaktirajte administratora."),
            );
          });
    }
  }

  void promeniIme(String name) async {
    setState(() {
      usernameEnabled = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
    var rezultat = await ApiPromenaPodataka.promeniIme(token, this.getIme);
    Navigator.pop(context);
    print(token);
    print(name);
    if (rezultat == true) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/PocetnaStrana', (Route<dynamic> route) => false);
      _dialog(context, "korisničko ime.");
    } else {
      setState(() {
        usernameEnabled = true;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greska"),
              content: Text("To korisničko ime je zauzeto."),
            );
          });
    }
  }

  void promeniSliku(File slika) async {
    setState(() {
      imageEnabled = false;
    });
    String base64Image = base64Encode(slika.readAsBytesSync());
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
    var rezultat = await ApiPromenaPodataka.promeniSliku(token, base64Image);
    Navigator.pop(context);
    if (rezultat == true) {
      print("uspesno");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/PocetnaStrana', (Route<dynamic> route) => false);

      _dialog(context, "sliku.");
    }
    if (rezultat == false) {
      setState(() {
        imageEnabled = true;
      });
      _falseDialog(context);
    }
  }

  _openGallery(BuildContext context) async {
    Navigator.pop(context);
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 1080,
        maxWidth: 1080);
    if (tempImage == null) return;
    this.setState(() {
      _image = tempImage;
      print(_image.lengthSync());
    });
    //promeniSliku(_image);
  }

  _openCamera(BuildContext context) async {
    Navigator.pop(context);
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxHeight: 1080,
        maxWidth: 1080);
    if (tempImage == null) return;
    this.setState(() {
      _image = tempImage;
      print(_image.lengthSync());
    });
    //promeniSliku(_image);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Odaberite'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  
              ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.image),
                          Text(" Galerija")
                        ],
                      ),
                      onTap: () {
                        _openGallery(context);
                      }),
                  Padding(padding: EdgeInsets.all(8.0)),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.add_a_photo),
                        Text(" Kamera")
                      ],
                    ),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
            
                ],
              ),
            ),
          );
        });
  }
}
