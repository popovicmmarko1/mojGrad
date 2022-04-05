import 'package:flutter/material.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';

class UserPreview  extends StatelessWidget{
  String username;
  String ime;
  String prezime;
  int id;
  String slika;
  int poeni=-10;

  UserPreview(this.username,this.ime,this.prezime,this.id,this.slika);
  UserPreview.saPoenima(this.username,this.ime,this.prezime,this.id,this.slika,this.poeni);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17)
      ),
      elevation: 5.0,
      margin:EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child:InkWell(
          onTap:(){
            Navigator.push(context,MaterialPageRoute(builder: (context) => PrikazProfila(id)),);
          } ,
          child: Container(
          decoration: BoxDecoration(color:Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(17)),
          child:ListTile(
            title: Text(username),
            subtitle: Text(ime+" "+prezime),
            contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical:8),
            leading:Container( padding:EdgeInsets.only(right:12.0),
            decoration:new BoxDecoration(
              border:new Border(right:new BorderSide(width:1.0,color:Colors.white24))
              ),
            child:CircleAvatar(backgroundImage: NetworkImage(slika)),
            ),
            trailing: poeni < 0 ? Container(width:1) : Text("Broj poena $poeni"),
          )
        ),
      )
    );
  }

  
}