

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderProfila extends StatefulWidget {
  int idKorisnika;
  String img;
  int objave;
  int komentari;
  int poeni;
  String bio;
  String username;
  String imePrezime;
  
  HeaderProfila(this.idKorisnika,this.img,this.poeni,this.bio,this.imePrezime);

  @override
  _HeaderProfilaState createState() => _HeaderProfilaState(idKorisnika,img,poeni,bio,imePrezime);
}

class _HeaderProfilaState extends State<HeaderProfila> {
  int idKorisnika;
  String img;
  int poeni;
  String bio;
  String imePrezime;
  
  _HeaderProfilaState(this.idKorisnika,this.img,this.poeni,this.bio,this.imePrezime);
  
  prikaziSliku(img){
    showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Image.network(
          img,
        ),
      );
    }
    );
  }
  
  @override
  Widget build(BuildContext context) {
   return Container(
     decoration:BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: new DecorationImage(
          fit: BoxFit.cover,
          colorFilter: 
            ColorFilter.mode(Colors.black.withOpacity(0.2), 
            BlendMode.dstATop),
          image: new NetworkImage(
            img,
          ),
        ),
      ),
    width: MediaQuery.of(context).size.width,
    child: Row(children: <Widget>[
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(imePrezime, style:TextStyle(fontWeight:FontWeight.bold)),
              Text("Biografija: "+bio),
              Text("Broj poena "+ poeni.toString())
            ],
          ),
        )
      ),
      GestureDetector(
          child: Container(//Profilna Slika
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(this.img),
          ),
        ),
        onTap: (){
          prikaziSliku(img);
        },
      ),
    ],
    ),
    );
  }
}

/*
          Row(
            children: <Widget>[
              Expanded(// Objave
                child: Column(
                  children: <Widget>[
                    Text("Objave",style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal) ),
                    Text(objave.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                  ],
                ),

              ),
               Expanded(// Komentari
                child: Column(
                  children: <Widget>[
                    Text("Događaji",style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal) ),
                    Text(komentari.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                  ],
                ),

              ),
              
              Expanded(//Broj Poena
                child: Column(
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.yellowAccent, size: 25,),
                    Text(poeni.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                  ],
                )
              )
            ],
          ),*/