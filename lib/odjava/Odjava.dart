import 'package:flutter/material.dart';
import 'package:moj_grad/tema/ThemeModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moj_grad/login_registracija/LoginStrana.dart';


class Odjava{
  
  static void OdjaviSe(context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Provider.of<ThemeModel>(context).defaultTheme();
    
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LoginStrana()), (Route<dynamic> route) => false);

    prefs.remove("username");
    prefs.remove("token");
    prefs.remove("image");
    prefs.remove("imePrezime");
    prefs.remove("idKorisnika");
    prefs.remove('radius');
    prefs.remove('themeBool');
  }
}