import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/adresa/Adresa.dart';
import 'package:moj_grad/dogadjaji/DogadjajDetalji.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';

class DogadjajPreview extends StatelessWidget {
  final String username;
  final String userImg;
  final String eventImg;
  final String naslov;
  final int userId;
  final String date;
  final String time;
  final int Id;
  final double x;
  final double y;
  DogadjajPreview(this.Id,this.userId,this.username,this.userImg,this.naslov,this.eventImg,this.date,this.time,this.x,this.y);
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        //border: Border.all(color: Theme.of(context).accentColor),
        color: Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 8.0,
              offset: const Offset(4, 4)
            )
          ]
      ),
        child: Column(
          
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: GestureDetector(
                child: Row(
                children: <Widget>[
                  CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(this.userImg), 
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(this.username,style: TextStyle(fontSize: 17.0),),
                      )
                ],
              ),
              onTap: (){prikaziProfil(context);},
              ),
            ),
            GestureDetector(
              child: Container(
                child: Text(this.naslov,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              
            ),
            onTap: (){prikaziDetalje(context);},
            ),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: Image(image: NetworkImage(this.eventImg), 
                fit: BoxFit.cover
              ),
              height: 200,
              width: double.infinity,
            ),
            onTap: (){prikaziDetalje(context);},
            ),
             
            GestureDetector(
              child:  Row(
              children: <Widget>[
                Expanded(child:Container(child:Text(this.date,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),alignment: Alignment.center,) ),
                Expanded(child:Container(child:Text(this.time,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),alignment: Alignment.center,) ),
                
                
                ],
                ),
                onTap: (){prikaziDetalje(context);},
            ),
           Container(
              margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
              width: (MediaQuery.of(context).size.width-32),
              child: FutureBuilder(
                future: Adresa.getAddressFromCoord(x, y),
                builder: (context,snap){
                  if(snap.data==null)
                    return Text("Lokacija",textAlign: TextAlign.center,);
                  else
                    return Text(snap.data,textAlign: TextAlign.center,);
                },
              ),
            ),
          ],

        ),


    );

  }
  void prikaziDetalje(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DogadjajDetalji(this.Id)),);
  }
  void prikaziProfil(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazProfila(this.userId)),);
  }
}