import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/pocetna/PocetnaStrana.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../post/PostSolution.dart';
import 'ApiLog.dart';
import 'RegistracijaStrana.dart';
import 'ZaboravljenaLozinka.dart';

class LoginStrana extends StatefulWidget {
  @override
  _LoginStranaState createState() => _LoginStranaState();
}

class _LoginStranaState extends State<LoginStrana> {
  final user = TextEditingController();
  final pass = TextEditingController();
  int idKorisnika;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //var fcmToken = await _firebaseMessaging.getToken();
  // String token="";

  bool _isEnabled = true;

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((v) {
      setState(() {
        idKorisnika = v.getInt("idKorisnika");
      });
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("ON MESSAGE-----------------");
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text(message['data']['title']),
              content: new Text(message['data']['body']),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "odustani",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostSolution(
                                  int.parse(message['data']['postId']),
                                  idKorisnika)));
                    },
                    child: Text(
                      "prikaži",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )),
              ],
            ));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostSolution(
                    int.parse(message['data']['postId']), idKorisnika)));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostSolution(
                    int.parse(message['data']['postId']), idKorisnika)));
      },
    );

    _firebaseMessaging.getToken().then((v) {
      print(v);
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  Future<bool> isLoged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null ||
        prefs.getInt("idKorisnika") == null ||
        prefs.getString("image") == null ||
        prefs.getString("imePrezime") == null ||
        prefs.getString("username") == null) {
      return false;
    }
    // var fcmToken = await _firebaseMessaging.getToken();
    //token = fcmToken;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isLoged(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
            //Navigator.push(context, MaterialPageRoute(builder: (context) => PocetnaStrana()),);
          } else if (snapshot.data == true) {
            return PocetnaStrana();
          } else {
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Container(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.asset(
                        "Slike/loginBot.png",
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          /*
                          Container(
                            child: Stack(
                              children: <Widget>[
                                Container(                                   //rec Moj
                                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                                  child: Text(
                                      'Moj',
                                      style: TextStyle(
                                          fontSize: 80.0,
                                          fontWeight: FontWeight.bold)
                                  ),
                                ),
                                Container(                                  //rec grad
                                  padding: EdgeInsets.fromLTRB(60.0, 175.0, 0.0, 0.0),
                                  child: Text(
                                      'Grad',
                                      style: TextStyle(
                                          fontSize: 80.0,
                                          fontWeight: FontWeight.bold)
                                  ),
                                ),
                                Container(                                         //tacka
                                    padding: EdgeInsets.fromLTRB(225.0, 175.0, 0.0, 0.0),
                                    child: Text(
                                      '.',
                                      style: TextStyle(
                                        fontSize: 80.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),*/
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 75.0, 0.0, 0.0),
                              child: Text(
                                "Moj grad",
                                style: TextStyle(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(
                              //username
                              padding: EdgeInsets.only(
                                  top: 15.0, left: 20.0, right: 20.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 55.0, right: 55.0),
                                    child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context)
                                                .nextFocus(),
                                        controller: user,
                                        decoration: InputDecoration(
                                            hintText: "Korisničko ime",
                                            fillColor:
                                                Theme.of(context).accentColor,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(32.0)),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(32.0)))),
                                  )
                                ],
                              )),
                          Container(
                            //password
                            padding: EdgeInsets.only(
                                top: 15.0,
                                left: 20.0,
                                right: 20.0,
                                bottom: 15.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 55.0, right: 55.0),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                    controller: pass,
                                    decoration: InputDecoration(
                                        hintText: "Lozinka ",
                                        fillColor:
                                            Theme.of(context).accentColor,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 15.0, 20.0, 15.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .accentColor)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0))),
                                    obscureText: true,
                                  ),
                                )
                              ],
                            ),
                          ),
                          RaisedButton(
                            //login dugme
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            elevation: 4.0,
                            child: Text(
                              "Prijavite se",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            onPressed: _isEnabled != true
                                ? null
                                : () {
                                    setState(() {
                                      _isEnabled = false;
                                    });
                                    ulogujSe(user.text, pass.text);
                                  },
                            color: Theme.of(context).accentColor,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            //margin: EdgeInsets.only(left: 40.0),
                            child: GestureDetector(
                              child: Text(
                                "Zaboravili ste lozinku?",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ZaboravljenaLozinka()),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: GestureDetector(
                              child: Text(
                                "Nemate nalog?",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistracijaStrana()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  void ulogujSe(String user, String pass) async {
    var fcmToken = await _firebaseMessaging.getToken();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
    var rezultat = await Api.proveriUsera(user, pass, fcmToken);
    Navigator.pop(context);
    //print(fcmToken + "fcmtoken");
    if (rezultat == true) {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => PocetnaStrana()),);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/PocetnaStrana');
    } else {
      setState(() {
        _isEnabled = true;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greska"),
              content: Text("Korisničko ime ili lozinka su neispravni."),
            );
          });
    }
  }
}
