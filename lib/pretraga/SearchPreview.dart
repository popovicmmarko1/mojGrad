import 'package:flutter/material.dart';
import 'package:moj_grad/dogadjaji/DogadjajDetalji.dart';
import 'package:moj_grad/post/PostSolution.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPreview  extends StatelessWidget{
  String naslov;
  int id;
  String tip;
  String slika;
  String datum;

  SearchPreview(this.tip,this.naslov,this.id,this.slika,this.datum);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17)
      ),
      elevation: 5.0,
      margin:EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child:InkWell(
          onTap:()async{
            SharedPreferences p =await SharedPreferences.getInstance();
            Navigator.push(context,MaterialPageRoute(
              builder: (context) => tip=='post' ? PostSolution(id, p.getInt('idKorisnika')) : DogadjajDetalji(id))
            );
          } ,
          child: Container(
          decoration: BoxDecoration(color:Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(17)),
          child:ListTile(
            leading: Container(
              padding:EdgeInsets.only(right:12.0),
              decoration:new BoxDecoration(
              border:new Border(right:new BorderSide(width:1.0,color:Colors.white24))
              ),
              child: CircleAvatar(backgroundImage: NetworkImage(slika),),
            ),
            title: Text(naslov),
            subtitle: (datum!=null) ? Text(datum) : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical:8),
          )
        ),
      )
    );
  }

  
}