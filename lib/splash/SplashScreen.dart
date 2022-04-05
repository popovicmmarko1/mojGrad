import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
 
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen>{

  void navigationPage() {
  Navigator.of(context).pushReplacementNamed('/LoginStrana');
}

  startTime() async {
    var _duration = new Duration(seconds:3);
    return new Timer(_duration, navigationPage);
  }

@override
  void initState() {
  super.initState();
  startTime();
}

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(child: Image.asset('Slike/splashImg.png',width: (MediaQuery.of(context).size.width * 9) / 10,))
    );
  }
  
}