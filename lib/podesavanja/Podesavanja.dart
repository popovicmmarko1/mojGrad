import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/pocetna/PocetnaStrana.dart';
import 'package:moj_grad/tema/ThemeModel.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiPromenaPodataka.dart';
import 'PromenaLozinke.dart';
import 'PromenaPodataka.dart';

class Podesavanja extends StatefulWidget {
  @override
  _PrikazPodesavanjaState createState() => _PrikazPodesavanjaState();
}

class _PrikazPodesavanjaState extends State<Podesavanja> {
  double rating;
  String message = "";
  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    SharedPreferences p = await SharedPreferences.getInstance();
    data['username'] = p.getString("username");
    data['image'] = p.getString("image");
    data['id'] = p.getInt("idKorisnika");
    data['imePrezime'] = p.getString("imePrezime");
    data['rating'] = p.getDouble('radius');

    return data;
  }

  bool _themeBool;

  void getThemeBool() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    _themeBool = p.getBool('themeBool');
    rating = p.getDouble('radius');
    message =
        " Izabrana udaljenost ${rating.toStringAsFixed(1)} km.";
  }

  @override
  void initState() {
    super.initState();
    getThemeBool();
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
                return Scaffold(
                    //backgroundColor: Colors.white,
                    appBar: AppBar(
                      title: Text(
                        'Podešavanja',
                      ),
                    ),
                    body: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            margin: const EdgeInsets.all(15.0),
                            color: Theme.of(context).accentColor,
                            child: ListTile(
                              onTap: () {
                                promeniPodatke(context);
                              },
                              title: Text(
                                snapshot.data['username'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data['image']),
                              ),
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Card(
                            elevation: 8.0,
                            margin: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  //lozinka
                                  leading: Icon(
                                    Icons.lock_outline,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  title: Text("Promena lozinke"),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    promeniLozinku(context);
                                  },
                                ),
                                Container(
                                  //linija izmedju pass i language
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  width: double.infinity,
                                  height: 1.0,
                                  color: Colors.grey,
                                ),
                                /*
                                ListTile(
                                  leading: Icon(
                                    Icons.language, color: Theme.of(context).accentColor,),
                                  title: Text("Promena jezika"),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {},
                                ),*/
                                /*Container( //linija izmedju pass i lokacija
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  width: double.infinity,
                                  height: 1.0,
                                  color: Colors.grey,
                                ),*/
                                SwitchListTile(
                                    contentPadding: EdgeInsets.all(8.0),
                                    value: _themeBool,
                                    activeColor: Theme.of(context).accentColor,
                                    //contentPadding: EdgeInsets.all(0),                    tema
                                    title: Text("Tamna tema"),
                                    onChanged: (val) async {
                                      Provider.of<ThemeModel>(context)
                                          .toggleTheme();
                                      SharedPreferences p =
                                          await SharedPreferences.getInstance();
                                      p.setBool(
                                          'themeBool', !p.getBool('themeBool'));
                                      setState(() {
                                        _themeBool = val;
                                      });
                                    },
                                    secondary: _themeBool == true
                                        ? Icon(
                                            Icons.brightness_3,
                                            color:
                                                Theme.of(context).accentColor,
                                          )
                                        : Icon(Icons.brightness_1,
                                            color:
                                                Theme.of(context).accentColor)),
                                Container(
                                  //linija izmedju teme i okruženja
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  width: double.infinity,
                                  height: 1.0,
                                  color: Colors.grey,
                                ),
                                ListTile(
                                  //lozinka
                                  /*leading: Icon(
                                    Icons.lock_outline,
                                    color: Theme.of(context).accentColor,
                                  ),*/
                                  title: Container(
                                      child: Column(
                                    children: <Widget>[
                                      Text("Širina okruženja"),
                                      Slider(
                                        value: rating,
                                        onChanged: (double e) => changed(e),
                                        label: rating.toString(),
                                        min: 1,
                                        max: 100,
                                        activeColor:
                                            Theme.of(context).accentColor,
                                        inactiveColor: Colors.grey,
                                      ),
                                      Text(message),
                                    ],
                                  )),
                                  trailing: Icon(Icons.check),
                                  onTap: () {
                                    promeniPoluprecnik(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                          /*SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Podešavanje poluprečnika",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          ),
                          Slider(
                            value: rating,
                            onChanged: (double e) => changed(e),
                            label: rating.toString(),
                            min: 1,
                            max: 100,
                            activeColor: Theme.of(context).accentColor,
                            inactiveColor: Colors.grey,
                          ),
                          Text(message),
                          RaisedButton(
                            onPressed: () {
                              promeniPoluprecnik(rating);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Potvrdi promenu poluprečnika',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                          ),*/
                        ],
                      ),
                    ));
              }
            }));
  }

  void promeniPodatke(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PromeniPodatke()),
    );
  }

  void promeniLozinku(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PromenaLozinke()),
    );
  }

  void changed(e) {
    setState(() {
      rating = e;

      message = " Izabrana udaljenost ${e.toStringAsFixed(1)} km.";
    });
  }

  void promeniPoluprecnik(double vrednost) async {
    print(vrednost);

    String token;

    SharedPreferences p = await SharedPreferences.getInstance();
    token = p.getString("token");
    p.setDouble('radius', vrednost);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
    var rezultat = await ApiPromenaPodataka.promeniPoluprecnik(token, vrednost);
    Navigator.pop(context);
    if (rezultat == true) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>PocetnaStrana()));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content: Text("Došlo je do greške, pokušajte ponovo."),
            );
          });
    }
  }
}
