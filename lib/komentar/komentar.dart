import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:moj_grad/dogadjaji/DogadjajDetalji.dart';
import 'package:moj_grad/post/PostSolution.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Komentar extends StatefulWidget {
  int userId;
  String userImg;
  String username;
  String komentar;
  int ocena;
  int komentarId;
  String tip;
  int idOdakleJe;
  int idKorisnikaTrenutnog;
  int mojaOcena;
  Komentar(this.userId, this.userImg, this.username, this.komentar, this.ocena,
      this.komentarId, this.tip, this.idOdakleJe,this.idKorisnikaTrenutnog,this.mojaOcena);

  @override
  _KomentarState createState() =>
      _KomentarState(userId, userImg, username, komentar, ocena, komentarId,idKorisnikaTrenutnog,mojaOcena);
}

class _KomentarState extends State<Komentar> {
  int userId;
  String userImg;
  String username;
  String komentar;
  int ocena;
  int komentarId;
  //bool reakcija = false;
  int mojaOcena;
  int idKorisnika;
  int idKorisnikaTrenutnog;
  String url = "http://147.91.204.116:2048/komentar/";
  _KomentarState(this.userId, this.userImg, this.username, this.komentar,
      this.ocena, this.komentarId,this.idKorisnikaTrenutnog,this.mojaOcena){
        print(mojaOcena.toString());
      }

  Future<int> ucitajKorisnika()async{
    SharedPreferences p =await SharedPreferences.getInstance();
    idKorisnika=p.getInt('idKorisnika');
    return idKorisnika;
  }

  @override
  void initState() {
    super.initState();
    ucitajKorisnika();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 5),
                child: GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage(userImg),
                    radius: 25.0,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrikazProfila(userId)),
                    );
                  },
                )),
            Expanded(
                child: Stack(children: <Widget>[
              Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5.0,
                      offset: const Offset(2, 2)
                    )
                  ]
                  ),
                  padding: new EdgeInsets.all(12),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: new Text(
                          username,
                          style: new TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrikazProfila(userId)),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: new Text(
                          komentar,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(Icons.thumb_up,size: 20,color: mojaOcena==1?Theme.of(context).accentColor:null,),
                            onTap: lajk,
                          ),
                          Text("  "+ocena.toString()+"  "),
                          GestureDetector(
                            child: Icon(Icons.thumb_down,size: 20,color: mojaOcena==-1?Theme.of(context).accentColor:null,),
                            onTap: dislajk,
                          ),
                        ],
                      ),
                    ],
                  )),
              FutureBuilder(
                future: ucitajKorisnika(),
                builder: (con,snap){
                  if(snap==null || userId!=idKorisnika)
                    return Container();
                  else
                  return Positioned(
                    right: 15,
                    top: 15,
                    child: InkWell(
                      child: Icon(
                        AntDesign.delete,
                        size: 20,
                        color: Theme.of(context).accentColor,
                      ),
                      onTap: () {
                        var res =obrisiKomentar().then((value){
                          if(value==true)
                            showDialog(context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Komentar je uspešno obrisan."),
                              );
                            }).then((value){
                              int id = widget.idOdakleJe;
                              Navigator.pop(context);
                              if(widget.tip=='post')
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PostSolution(id,idKorisnika)),);
                              else
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DogadjajDetalji(id)),);
                            });
                          else
                            showDialog(context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Došlo je do greške prilikom brisanja komentara."),
                              );
                            });
                        });
                      },
                    ),
                  );
              })
            ])),
          ],
        ),
      ],
    ));
  }

  void lajk() async {
    if (mojaOcena == 0 || mojaOcena==-1) {
      Response res;
      if (widget.tip == "post") {
        res = await http.get(url + "like/" + komentarId.toString()+"/"+idKorisnikaTrenutnog.toString());
      } else {
        res = await http.get(url + "likeDogadjaj/" + komentarId.toString()+"/"+idKorisnikaTrenutnog.toString());
      }
      if (res.statusCode == 200) {
        setState(() {
          mojaOcena++;
          ocena++;
        });
        print("lajkovano " + komentarId.toString());
      } else {
        print("greska pri lajkovanju " + komentarId.toString());
        print(url + "like/" + komentarId.toString());
      }
    }
  }

  void dislajk() async {
    if (mojaOcena == 0 || mojaOcena==1) {
      Response res;
      if (widget.tip == "post") {
        res = await http.get(url + "dislike/" + komentarId.toString()+"/"+idKorisnikaTrenutnog.toString());
      } else {
        res = await http.get(url + "dislikeDogadjaj/" + komentarId.toString()+"/"+idKorisnikaTrenutnog.toString());
      }
      if (res.statusCode == 200) {
        setState(() {
          mojaOcena--;
          ocena--;
        });
        print("dislajkovano " + komentarId.toString());
      } else {
        print("greska pri dislajkovanju " + komentarId.toString());
        print(url + "dislike/" + komentarId.toString());
      }
    }
  }

  Future<bool> obrisiKomentar()async{
    Response res;
    try{
      if (widget.tip == "post") {
        res = await http.get(url + "obrisi/" + komentarId.toString());
      } else {
        res = await http.get(url + "obrisiDogadjaj/" + komentarId.toString());
      }
    }catch(e){
      print(e);
    }
    if(res.statusCode==200){
      return true;
    }
    return false;
  }
}
