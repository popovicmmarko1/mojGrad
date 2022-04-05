import 'package:flutter/material.dart';

import 'Statistika2.dart';

class Grafik extends StatefulWidget {
  @override
  _GrafikState createState() => _GrafikState();
}

class _GrafikState extends State<Grafik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Izazovi"),),
      body: Statistika2(),
    );
  }
}