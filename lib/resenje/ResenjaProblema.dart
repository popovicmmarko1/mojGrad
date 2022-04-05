import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moj_grad/resenje/ResenjeContainer.dart';
import 'package:moj_grad/resenje/resenje.dart';

class ResenjaProblema extends StatefulWidget {
  @override
  int idPosta;
  int idKorisnika;
  ResenjaProblema(this.idPosta,this.idKorisnika);
  _ResenjaProblemaState createState() => _ResenjaProblemaState(idPosta,idKorisnika);
}

class _ResenjaProblemaState extends State<ResenjaProblema> {
  
  int idPosta;
  int idKorisnika;

  _ResenjaProblemaState(this.idPosta,this.idKorisnika);

  Future<List<ResenjeContainer>> dajResenja() async{
   
    List<ResenjeContainer> lista = []; 
   
    var response =await http.get("http://147.91.204.116:2048/resenje/"+widget.idPosta.toString());
    if(response.statusCode==200){
      var jsonData = json.decode(response.body); 
      for(var d in jsonData){
        List<String> slike = List<String>();
        for(var s in d['slike']){
          slike.add(s);
        }
        ResenjeContainer temp = ResenjeContainer(d['autorPosta'],widget.idPosta, widget.idKorisnika, DateTime.parse(d['datum']), d['userImg'], d['userId'], d['ocena'], d['opis'], slike, d['username'],d['id']);
        lista.add(temp);
      }
    }
    return lista;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: dajResenja(),
          builder: (BuildContext context,AsyncSnapshot snapshot)
          {
            if(snapshot.data==null){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.data.length==0){
              print(snapshot.data.length);
              return Center(child: Text("Još uvek nema rešenja", style: TextStyle(color: Theme.of(context).accentColor,fontSize: 20),),);
            }
            else{
                return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context,int index){
                  return snapshot.data[index];
                }
              );
            }
          }
          ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>DodajResenje(idPosta)));
        },
        child: Container(        
            //child: Icon(Icons.add_a_photo, color: Colors.white,)
            child: Text("Reši", style: TextStyle(color: Colors.white),)
          ),
        )
    );
  }
}