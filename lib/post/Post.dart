import 'package:flutter/material.dart';
import 'package:moj_grad/adresa/Adresa.dart';
import 'package:moj_grad/post/PostSolution.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';

class Post extends StatelessWidget{

  int userId;
  String userImg;
  String naslov;
  int postId;
  String prvaSlika;
  String slikaResenja;
  int idKorisnika;
  String username;
  double x,y;
  String medalja;

  Post(this.idKorisnika,this.username,this.userId,this.naslov,this.postId,this.prvaSlika,this.slikaResenja,this.x,this.y,this.userImg);

  Widget getImages(context){
      return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(14, 0, 5, 0),
          width: MediaQuery.of(context).size.width /2 -20,
          height:230,
          child: Image(image: NetworkImage(prvaSlika),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(5, 0, 14, 0),
          width: MediaQuery.of(context).size.width /2 -20,
          height:230,
          child: slikaResenja !=null ? 
          Image(image: NetworkImage(slikaResenja),
            fit: BoxFit.cover,
          ) :
          Image.asset('Slike/nemaResenja.png', fit: BoxFit.fitHeight),
        ),
      ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => PostSolution(postId,idKorisnika)),);
      },
        child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(17),
          //border: Border.all(color: Colors.black),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 8.0,
              offset: const Offset(4, 4)
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[ 
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
              child: GestureDetector(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(this.userImg), 
                  ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(child: Text(username,textAlign: TextAlign.left,style: TextStyle(fontSize: 17),)),
                    ),
                  ],
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazProfila(userId)),);
                },
              ),
            ),
            ListTile(
              dense: true,
                contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                title: Text(naslov, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
            ),
            getImages(context),
            Container(
              margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
              width: (MediaQuery.of(context).size.width-32),
              child: FutureBuilder(
                future: Adresa.getAddressFromCoord(x, y),
                builder: (context,snap){
                  if(snap.data==null)
                    return Text("Lokacija");
                  else
                    return Text(snap.data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}