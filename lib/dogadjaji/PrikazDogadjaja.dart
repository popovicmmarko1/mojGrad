import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:intl/intl.dart';
import 'package:moj_grad/dogadjaji/DogadjajPreview.dart';
import 'package:http/http.dart' as http;
import 'package:moj_grad/mapa/mapaApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DodajDogadjaj.dart';
class PrikazDogadjaja extends StatefulWidget {
  @override
  _PrikazDogadjajaState createState() => _PrikazDogadjajaState();
}

class _PrikazDogadjajaState extends State<PrikazDogadjaja> {

  final DateTime datum = new DateTime.now();
  List<DogadjajPreview> dogadjaji = null;
  int idPoslednjeg;
  int idKorisnika;
  bool hasNext=true;

  int vrednostRadio=0;
 
 void initState(){
    super.initState();
   
    idPoslednjeg=0;

    loadKorisinik();
    
    /*sc.addListener((){
      if(sc.position.pixels==sc.position.maxScrollExtent){
        print(idPoslednjeg.toString());
        fetch();
      }
    });*/
    fetch();
  }
  void loadKorisinik()async{
    SharedPreferences s = await SharedPreferences.getInstance();
    idKorisnika=s.getInt('idKorisnika');
  }

   void fetch() async{
    http.Response response;
    SharedPreferences s = await SharedPreferences.getInstance();
    var pozicija = await MapaAPI.dajPoziciju();
    try{
     /* var url = "http://10.0.2.2:62054/dogadjaj/"+pozicija.latitude.toString()+"/"+pozicija.longitude.toString()+"/"+s.getDouble("radius").toString()+"/"+idPoslednjeg.toString();
      print(url);*/
      response = await http.get("http://147.91.204.116:2048/dogadjaj/"+pozicija.latitude.toString()+"/"+pozicija.longitude.toString()+"/"+s.getDouble("radius").toString()+"/"+idPoslednjeg.toString());
    }
    catch(e){
      print(e.toString());
    }
    print(response.statusCode.toString());
    if(response.statusCode==200){
      if(dogadjaji==null){
        setState(() {
        dogadjaji=[];
      });
      }
      var jsonData = json.decode(response.body);
      print(jsonData.length.toString());
      if(jsonData.length<5){
        setState(() {
          hasNext=false;
        });
      }
       for(var e in jsonData){
        var datum = new DateFormat('dd.MM.yyyy').format(DateTime.parse(e['datum']));
        var vreme = new DateFormat('HH:mm ').format(DateTime.parse(e['datum']));
        DogadjajPreview temp = new DogadjajPreview(e['idEventa'],e['idKorisnika'], e['username'], e['userImg'], e['naslov'], e['eventImg'], datum, vreme,e['x'],e['y']);
        setState(() {
          dogadjaji.add(temp);
          idPoslednjeg=temp.Id;  
        });
      }
      
    }
    
  }

  Future<Null> refresh() async{
    setState(() {
      dogadjaji=null;
      idPoslednjeg=0;
      hasNext=true;
    });
    fetch();
    return null;
  }


  /*Future<List<Widget>> getData() async{
    //Map<String,dynamic> map = new Map<String,dynamic>();
    double x;
    double y;
    List<DogadjajPreview> list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Dodati ucitavanje lokacije
    var pozicija = await MapaAPI.dajPoziciju();
    x=pozicija.latitude;
    y=pozicija.longitude;
    var radius = prefs.getDouble("radius"); 
    var response = await http.get("http://147.91.204.116:2048/dogadjaj/"+x.toString()+"/"+y.toString()+"/"+radius.toString());
    if(response.statusCode==200){
      var jsonData = json.decode(response.body);
      for(var e in jsonData){
        var datum = new DateFormat('dd.MM.yyyy').format(DateTime.parse(e['datum']));
        var vreme = new DateFormat('HH:mm ').format(DateTime.parse(e['datum']));
        DogadjajPreview temp = new DogadjajPreview(e['idEventa'],e['idKorisnika'], e['username'], e['userImg'], e['naslov'], e['eventImg'], datum, vreme);
        list.add(temp);
      }
      return list;
    }
    return null;
  }*/
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Događaji")),
      body:dogadjaji==null?
        Center(child: Container(
          margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/3),
          child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Uključite lokaciju na vašem uređaju.",style: TextStyle(color: Theme.of(context).accentColor),),
            ),
            CircularProgressIndicator(),
          ],
        )),):
         RefreshIndicator(
          child: dogadjaji.length>0? 
          InfiniteListView(
            itemBuilder: (context, index){
              return dogadjaji[index];
            }, 
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: dogadjaji.length, 
            nextData: fetch,
            hasNext: hasNext==true,
            ):SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(), child: Column(children: <Widget>[Container(height:MediaQuery.of(context).size.height, alignment: Alignment.center, child: Text("Još uvek nema događaja u vašoj blizini",style: TextStyle(color:Theme.of(context).accentColor),),)],),),
          onRefresh: refresh,
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NapraviDogadjaj(datum)),
          );
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add,color: Colors.white),
      ),
      );
  }
}