import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/dogadjaji/ApiDogadjaj.dart';
import 'package:moj_grad/korisnik/UserPreview.dart';

class PrikazZainteresovanih extends StatefulWidget {
  int id;
  PrikazZainteresovanih(this.id);
  @override
  _PrikazZainteresovanihState createState() => _PrikazZainteresovanihState();
}

class _PrikazZainteresovanihState extends State<PrikazZainteresovanih> {
  
  List<UserPreview> prisutni = [];

  @override
  void initState() {
    super.initState();
    ApiDogadjaj.prikazZainteresovanih(widget.id).then((v){
      
      setState(() {
        prisutni=v;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Zainteresovani"),),
      body: ListView.builder(
        itemCount: prisutni.length,
        itemBuilder: (context, index){
          return prisutni[index];
        },
      ),
    );
  }
}