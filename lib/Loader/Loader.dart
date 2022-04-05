import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {

  bool _themeBool;
  
  loadTheme()async{
    SharedPreferences p = await SharedPreferences.getInstance();
    _themeBool = p.getBool('themeBool');
  }

  @override
  void initState() {
    super.initState();
    loadTheme();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: (_themeBool==null) ? Image.asset('Slike/loader.gif') : 
        _themeBool==true? Image.asset('Slike/loaderDark.gif') : Image.asset('Slike/loaderLight.gif')),
    );
  }
}