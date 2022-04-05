import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/kalendar/Kalendar.dart';
import 'package:moj_grad/najjaci_korisnici/top10.dart';
import 'package:moj_grad/odjava/Odjava.dart';
import 'package:moj_grad/podesavanja/Podesavanja.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moj_grad/dogadjaji/PrikazDogadjaja.dart';
import '../mapa/Mapa.dart';
import 'package:moj_grad/mapa/Mapa.dart';
import 'package:flutter_icons/flutter_icons.dart';


class BocnaNavigacija extends StatelessWidget {
  
  Future<Map<String,dynamic>> getData() async{
    Map<String,dynamic> data = new Map<String,dynamic>();
    SharedPreferences p = await SharedPreferences.getInstance();
    data['username']=p.getString("username");
    data['image']=p.getString("image");
    data['id']=p.getInt("idKorisnika");
    data['imePrezime']=p.getString("imePrezime");
    return data;
  }
  
  @override
  Widget build(BuildContext context) {
    return Drawer( 
      child:FutureBuilder(
        future: getData(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.data==null){
            return Container(
              child: CircularProgressIndicator(),
            );
          }
          else{
            return ListView(
         children: <Widget>[
           Container(//Profilna Slika
             padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
             alignment: Alignment.center,
             child: CircleAvatar(
               radius: 50,
              backgroundImage: NetworkImage(snapshot.data['image']),
             ),
           ),
            Container( // Ime i prezime
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(snapshot.data['imePrezime'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Container( // Korisnicko ime
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(snapshot.data['username'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            ),
            //Divider(height: 0,color: Theme.of(context).dividerColor,thickness: 2,),//Horizontalna linija
            ListTile(//profil
            leading: Icon(Icons.account_circle),
            title: Text("Profil",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            onTap: (){otvoriProfil(context,snapshot.data['id']);},
              ),
            ListTile(//dogadjaji
            leading: Icon(Icons.event),
            title: Text("Događaji",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            onTap: (){otvoriDogadjaje(context);},
              ),
           ListTile(//kalendar
             leading: Icon(FlutterIcons.event_available_mdi),
             title: Text("Kalendar",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
             onTap: (){otvoriKalendar(context);},
           ),
            ListTile(//geo
            leading: Icon(FlutterIcons.map_fou),
            title: Text("Mapa",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            onTap: (){otvoriGeo(context);},
              ),
              ListTile(
            leading: Icon(Icons.stars),
            title: Text("Top 10 korisnika",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            onTap: (){otvoriTop(context);},
              ),
            ListTile(//podesavanja
            leading: Icon(Icons.settings),
            title: Text("Podešavanja",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            onTap: (){otvoriPodesavanja(context);},
              ),
            ListTile(// odjavi se
            leading: Icon(Icons.exit_to_app,color: Colors.red,),
            title: Text("Odjavi Se",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color: Colors.red),),
            onTap: (){Odjava.OdjaviSe(context);},
              ),
         ],
       );
          }
        }
        )
       
    );
  }

  void otvoriPodesavanja(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Podesavanja()),);
  }
  void otvoriProfil(context,int id){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazProfila(id)),);
  }
  void otvoriDogadjaje(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazDogadjaja()),);
  }
  void otvoriKalendar(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazKalendara()),);
  }
  void otvoriGeo(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Mapa()),);
  }
  void otvoriTop(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Top10()),);
  }
}