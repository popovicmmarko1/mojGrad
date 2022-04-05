import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/pocetna/PocetnaStrana.dart';

import 'ApiLog.dart';

class RegistracijaStrana extends StatefulWidget {
  @override
  _RegistracijaStranaState createState() => _RegistracijaStranaState();
}

class _RegistracijaStranaState extends State<RegistracijaStrana> {
  final user = TextEditingController();
  final pass = TextEditingController();
  final pass1 = TextEditingController(); //ponovljena lozinka
  final ime = TextEditingController();
  final prezime = TextEditingController();
  final email = TextEditingController();

  bool _isEnabled = true;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String token = "";

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text("Registracija"),
        ),
        body: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            Container(                              //Name
              padding: EdgeInsets.only(top: 15.0,left: 20.0,right: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: ime,
                    decoration: InputDecoration(
                        labelText: "Ime",
                        hintText: "Ime",
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        fillColor: Theme.of(context).accentColor,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Theme.of(context).accentColor)
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  )
                ],
              ),
            ),
            Container(                                                    //Lastname
              padding: EdgeInsets.only(top: 15.0,left: 20.0,right: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: prezime,
                    decoration: InputDecoration(
                        labelText: "Prezime",
                        hintText: "Prezime",
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        fillColor: Theme.of(context).accentColor,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Theme.of(context).accentColor)
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))

                    ),
                  )
                ],
              ),
            ),
            Container(                                                   //username
              padding: EdgeInsets.only(top: 15.0,left: 20.0,right: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: user,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: "Korisničko ime",
                      hintText: "Korisničko ime",
                      labelStyle: TextStyle(color: Theme.of(context).accentColor),
                      fillColor: Theme.of(context).accentColor,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          borderSide: BorderSide(color: Theme.of(context).accentColor)
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  )
                ],
              ),
            ),
            Container(                                                 //email
              padding: EdgeInsets.only(top: 15.0,left: 20.0,right: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Vaš e-mail",
                        hintText: "E-mail",
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        fillColor: Theme.of(context).accentColor,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Theme.of(context).accentColor)
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  )
                ],
              ),
            ),
            Container(                                                 //password
              padding: EdgeInsets.only(top: 15.0,left: 20.0,right: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: pass,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(_secureText ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).accentColor),
                        ),
                        labelText: "Lozinka",
                        hintText: "Lozinka",
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        fillColor: Theme.of(context).accentColor,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Theme.of(context).accentColor)
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    obscureText: _secureText,
                  )
                ],
              ),
            ),
            Container(                                         //confirm password
              padding: EdgeInsets.only(top: 15.0,left: 20.0,right: 20.0,bottom: 35.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: pass1,
                    decoration: InputDecoration(
                        labelText: "Potvrdite lozinku",
                        hintText: "Potvrdite lozinku",
                        suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(_secureText ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).accentColor),
                        ),
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        fillColor: Theme.of(context).accentColor,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Theme.of(context).accentColor)
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    obscureText: _secureText,
                  )
                ],
              ),
            ),

            RaisedButton(                                                //registration dugme
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              elevation: 3.0,
              child: Text("Registrujte se",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
              onPressed: _isEnabled!=true ? null : (){
                if(ime.text.trim()=="" || prezime.text.trim()=="" || user.text.trim()=="" || pass.text.trim()=="" || pass1.text.trim()=="" || email.text.trim()=="") {
                  showDialog(context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Upozorenje"),
                          content: Text("Sva polja moraju biti popunjena."),
                        );
                      });
                }
                else {
                  if(_isEnabled == true){
                    registrujSe(ime.text,prezime.text,user.text,pass.text, pass1.text,email.text);
                  }
                  }
                  },
              color: Theme.of(context).accentColor,),
              Padding(
                padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
              ),
          ],
            ),
        )

    );
  }


  void registrujSe(String ime, String prezime, String username, String password, String pass1,String email) async{
    setState(() {
      _isEnabled = false;
    });
    var fcmToken = await _firebaseMessaging.getToken();
    var proveraPass = password.toString();
    String proveraEmail = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";

    RegExp regExp = new RegExp(proveraEmail);
    if(!(regExp.hasMatch(email))){
      setState(() {
              _isEnabled=true;
            });
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content: Text("Niste uneli validnu email adresu"),
            );
          });
    }


    else if(proveraPass.length < 6) {
      setState(() {
              _isEnabled=true;
            });
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content: Text("Lozinka mora imati minimum 6 karaktera."),
            );
          });
    }

    else if(username.contains(' ')){
      setState(() {
              _isEnabled=true;
            });
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content: Text("Username ne sme sadrzati razmak."),
            );
          });
    }



    else if (password != pass1) {
      setState(() {
              _isEnabled=true;
            });
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greška"),
              content: Text("Unete lozinke se ne podudaraju."),
            );
          });
    }

    else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
      var rezultat = await Api.registrujSe(ime,prezime,username,password,email,fcmToken);
      Navigator.pop(context);
      if(rezultat=="ok"){
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => PocetnaStrana()),);
      }
      else if(rezultat=="email"){
        setState(() {
          _isEnabled = true;
        });
        showDialog(context: context,
            builder: (BuildContext context){
              return  AlertDialog(
                title: Text("Greška"),
                content: Text("Ova email adresa je već u upotrebi."),
              );
            });
      }
      else if(rezultat=="username"){
        setState(() {
          _isEnabled = true;
        });
        showDialog(context: context,
            builder: (BuildContext context){
              return  AlertDialog(
                title: Text("Greška"),
                content: Text("Ovo korisničko ime je zauzeto. Izaberite drugo"),
              );
            });
      }
      else{
        setState(() {
          _isEnabled = true;
        });
        showDialog(context: context,
            builder: (BuildContext context){
              return  AlertDialog(
                title: Text("Greška"),
                content: Text("Pokušajte ponovo"),
              );
            });
      }
    }
  }
}



