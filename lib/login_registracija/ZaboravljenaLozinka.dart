import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/login_registracija/LoginStrana.dart';
import 'ApiResetovanjeSifre.dart';

class ZaboravljenaLozinka extends StatefulWidget {
  @override
  _ZaboravljenaLozinkaState createState() => _ZaboravljenaLozinkaState();
}

class _ZaboravljenaLozinkaState extends State<ZaboravljenaLozinka> {

  final TextEditingController _kontroler = new TextEditingController();
  //final TextEditingController _email = new TextEditingController();

  String get getKontroler => _kontroler.text;
 // String get getEmail => _email.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Resetovanje lozinke"),
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(                                //pozadina dela za menjanje sa borderradius
                  elevation: 8.0,
                  margin: EdgeInsets.fromLTRB(32.0, 80.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                          ])),
                ),
                //////////////////////////////////////////////////
                Card(
                  elevation: 8.0,
                  margin: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(                             //tekst za podatak
                            margin: EdgeInsets.only(top: 15.0),
                            child: Text("Unesite korisničko ime ili e-mail adresu: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 2,
                              ),)),
                        TextField(                //polje za podatak
                            textAlign: TextAlign.center,
                            controller: _kontroler,
                            decoration: InputDecoration(
                              fillColor: Colors.grey,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).accentColor),
                              ),
                            )),
                        Container(   //prazan na dnu
                          height: 20.0,
                        )

                      ],

                    ),


                  ),

                )])),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          resetujSifru(_kontroler.text);
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.check),
      ),
    );
  }

  void resetujSifru(String podatak) async{
      if(podatak == '')
        {
          showDialog(context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Greška!"),
                  content: Text("Morate uneti korisničko ime ili e-mail adresu!"),
                );
              });
        }
      else{
//print(email);
//print(username);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Loader()),);
        var rezultat = await ApiResetovanjeSifre.resetujPass( this.getKontroler);
        Navigator.pop(context);
        if(rezultat==true){
          print("uspesno");
         Navigator.push(context, MaterialPageRoute(builder: (context) => LoginStrana()),);
        }
        else{
          showDialog(context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Greška!"),
                  content: Text("Korisničko ime ili e-mail adresa ne postoje!"),
                );
              });
        }
        }

      }

    }

