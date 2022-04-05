import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/pocetna/PocetnaStrana.dart';
import 'package:moj_grad/podesavanja/ApiPromenaPodataka.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromenaLozinke extends StatefulWidget{

  @override
  _PromenaLozinkeState createState() => _PromenaLozinkeState();
}

class _PromenaLozinkeState extends State<PromenaLozinke>with TickerProviderStateMixin{
  final TextEditingController _oldPassword = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _confirmPassword = new TextEditingController();

  String token = '';

  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNode = FocusNode();
  bool enabled =true;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 80.0, end: 300.0).animate(_controller)
    ..addListener(() {
      setState(() {});
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  String get getOld => _oldPassword.text;
  String get getPass => _password.text;
  String get getPass1 => _confirmPassword.text;

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    SharedPreferences p = await SharedPreferences.getInstance();
    data['username'] = p.getString("username");
    data['image'] = p.getString("image");
    data['id'] = p.getInt("idKorisnika");
    data['imePrezime'] = p.getString("imePrezime");
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
              }
              else {
                token = snapshot.data['token'];
                return Scaffold(
                    resizeToAvoidBottomPadding: false,
                    appBar: AppBar(
                      title: Text("Promena lozinke"),
                    ),
                    body: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Card(                                //pozadina dela za menjanje sa borderradius
                                elevation: 8.0,
                                margin: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 16.0),
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
                                      Container(                             //tekst lozinka
                                          margin: EdgeInsets.only(top: 15.0),
                                          child: Text("Trenutna lozinka",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 2,
                                            ),)),
                                      TextField(                //polje za trenutnu lozinku
                                          textAlign: TextAlign.center,
                                          controller: _oldPassword,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Theme.of(context).accentColor),
                                            ),
                                          )),
                                      Container(                             //tekst lozinka
                                          margin: EdgeInsets.only(top: 15.0),
                                          child: Text("Nova lozinka",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 2,
                                            ),)),
                                      TextField(                //polje za novu lozinku
                                          textAlign: TextAlign.center,
                                          controller: _password,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Theme.of(context).accentColor),
                                            ),
                                          )),
                                      Container(                                //linija
                                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                                        width: double.infinity,
                                        height: 1.0,
                                        color: Colors.grey,
                                      ),
                                      Container(                           //ponovi lozinku tekst
                                          margin: EdgeInsets.only(top: 15.0),
                                          child: Text("Ponovite lozinku",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 2,
                                            ),)),
                                      TextField(  
                                        focusNode: _focusNode,                             //polje za lozinku
                                          obscureText: true,
                                          textAlign: TextAlign.center,
                                          controller: _confirmPassword,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Theme.of(context).accentColor),
                                            ),
                                          )),
                                      Container(   //prazan na dnu
                                        height: 10.0,
                                      ),

                                    ],

                                  ),


                                ),

                              ),
                              SizedBox(height: _animation.value),
                              ])),
                    floatingActionButton: FloatingActionButton(
                    onPressed: enabled==true?(){
                      promeniSifru(_oldPassword.text,_password.text, _confirmPassword.text);
                      }:null,
                       backgroundColor: Theme.of(context).accentColor,
                        child: Icon(Icons.check,color: Colors.white,),
              ),);
              }
            }
        ));
  }



  void promeniSifru(String old, String pass, String pass1) async{
    if(pass!=pass1){
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Greška"),
              content: Text("Unete lozinke se ne podudaraju."),
            );
          });
    }
    else{
      setState(() {
        enabled=false;
      });
       Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
      var rezultat = await ApiPromenaPodataka.promeniPass(token, this.getOld,this.getPass);
      Navigator.pop(context);
      setState(() {
        enabled=true;
      });
      if(rezultat==true){
        print("uspesno");
         Navigator.of(context).pushNamedAndRemoveUntil(
          '/PocetnaStrana', (Route<dynamic> route) => false);
        showDialog(context: context,builder: (BuildContext context){
            return AlertDialog(
              content: Text("Uspešno ste promenili lozinku."),
            );
          });
      }
    }
  }



}