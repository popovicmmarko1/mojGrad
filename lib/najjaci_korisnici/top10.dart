
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:moj_grad/korisnik/UserPreview.dart';

class Top10 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Top10State();
}

class _Top10State extends State<Top10>{

  Future<List> getData()async{
    List lista = [];

    http.Response response;

    try{
      response = await http.get('http://147.91.204.116:2048/korisnik/top10');
    }
    catch(e){
      print(e);
    }

    if(response.statusCode==200){
       var data = json.decode(response.body);

       for(var i in data){
         lista.add(UserPreview.saPoenima(i['username'], i['ime'], i['prezime'], i['id'], i['slika'],i['poeni']));
       }

       return lista;
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top 10 korisnika"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snap) {
          if (snap.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snap.data.length,
            itemBuilder: (context, index) {
              return snap.data[index];
            }
          );
        },
      )
    );
  }

}