import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:moj_grad/adresa/Adresa.dart';
import 'package:moj_grad/komentar/Komentar.dart';
import 'package:moj_grad/mapa/Mapa.dart';
import 'package:moj_grad/odjava/Odjava.dart';
import 'package:moj_grad/post/PostSolution.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiPost.dart';

class PostPage extends StatefulWidget {
  int postId;
  int idKorisnika;

  PostPage(this.postId,this.idKorisnika);

  @override
  _PostPageState createState() => _PostPageState(postId,idKorisnika);
}


class _PostPageState extends State<PostPage> {
  TextEditingController newPostController = TextEditingController();

  int postId;
  int idKorisnika;
  String naslov;
  String detalji;
  bool _enabledCom=true;

  _PostPageState(this.postId,this.idKorisnika) {
    loadData(postId);
  }
  Future loadData(int postId) async {
    var response = await http.get(Uri.encodeFull('http://147.91.204.116:2048/izazov/' + postId.toString()+"/"+idKorisnika.toString()));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data;
    }

    return null;
  }

  void postaviNaslov(int postId) async {
    try{
      var response = await http.get(Uri.encodeFull('http://147.91.204.116:2048/izazov/' + postId.toString()));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          naslov=data['naslov'];
          if(data['detalji'] != null)
            detalji=data['detalji'];
        });
      }
    }catch(e){
      print(e);
    }
  }


  List getImages(imgUrl){

    List images=[];

    for(var url in imgUrl)
      images.add(NetworkImage(url));

    return images;
  }

  Widget imageSlider(slike){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      constraints: BoxConstraints(maxHeight: 350),
      child:Carousel(
        dotSize: 4.0,
        dotBgColor: Colors.transparent,
        dotSpacing: 10,
        dotColor: Theme.of(context).accentColor,
        autoplay: false,
        boxFit: BoxFit.fitHeight,
        images: getImages(slike)
      )
    );
  }

   Widget dajDugme(context,postId,userId,idKorisnika,naslov,detalji) {

      if(userId == idKorisnika ){
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        FlatButton(onPressed:() async{
           _editDialog(context, postId, naslov, detalji).then((val){
             if(val != null && val == true){
               postaviNaslov(postId);
             }
           });
        },
         child: Text("Izmeni izazov", style: TextStyle(color:Theme.of(context).accentColor),)
         ),
        FlatButton(onPressed:(){
          _deleteDialog(context, postId).then((value) {
            if(value != null && value==true){
              Navigator.pop(context);
            }
          });
        },
         child: Text("Obriši izazov", style: TextStyle(color:Theme.of(context).accentColor),)
         )
      ],);
      }
      else{
        return FlatButton(onPressed: (){
          _reportDialog(context, postId);
        },
        child: Text("Prijavi izazov", style: TextStyle(color:Theme.of(context).accentColor),)
        );
      }
  }

  static Future<bool> _editDialog(BuildContext context,postId,String naslov,String detalji){
    TextEditingController _naslov = TextEditingController();
    _naslov.text=naslov;
    TextEditingController _opis = TextEditingController();
    _opis.text=detalji;

    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _naslov,
              maxLength: 80,
              decoration: InputDecoration(
                hintText: "Neophodno je uneti naslov"
              ),
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              maxLength: 255,
              controller: _opis,
              decoration: InputDecoration(
                hintText: "Opis"
              ),
            ),
            ],
        ),
          ),
        actions: <Widget>[
          new FlatButton(onPressed: ()async{
            if(_naslov.text != ""){
              var res= await ApiPost.editPost(context,postId, _naslov.text, _opis.text);

              if(res){
                Navigator.pop(context,true);
              }
              else{
                Navigator.pop(context,false);
              }
            }
          },
           child: Text("Izmeni"))
        ],
      );
    });
  }

  static Future<void> _reportDialog(BuildContext context,postId){
    TextEditingController _razlog = TextEditingController();

    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('Unesite razlog prijave'),
        content: TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: _razlog,
          decoration: InputDecoration(
            hintText: "Razlog prijave"
          ),
        ),
        actions: <Widget>[
          new FlatButton(onPressed: ()async{
            var res= await ApiPost.prijaviPost(context,_razlog.text,postId);
            
            if(res)
              Navigator.of(context).pop();
          },
           child: Text("Prijavi"))
        ],
      );
    });
  }

  static Future<bool>_deleteDialog(BuildContext context,postId){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Vaš izazov će biti obrisan, da li ste sigurni?"),
        actions: <Widget>[
          FlatButton(
            onPressed: ()async{
              var res=await ApiPost.deletePost(context,postId);

              if(res)
                Navigator.pop(context,true);
              else
                Navigator.pop(context,false);
            },
             child: Text("Da")
          ),
          FlatButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
             child: Text("Ne")
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            margin: EdgeInsets.all(5),
            child: FutureBuilder(
              future: loadData(postId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  naslov = snapshot.data['naslov'];
                  detalji = snapshot.data['detalji'];
                  return SingleChildScrollView(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        dajDugme(
                          context, postId, snapshot.data['userId'], idKorisnika, snapshot.data['naslov'],snapshot.data['detalji']
                          ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          color: Theme.of(context).accentColor,
                          child: ListTile(
                            title: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        PrikazProfila(
                                            snapshot.data['userId'])));
                              },
                              child: Text(snapshot.data['username'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                              NetworkImage(snapshot.data['userImg']),
                            ),
                            trailing: Text(new DateFormat('dd.MM.yyyy').format(DateTime.parse(snapshot.data['datum'])),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                        imageSlider(snapshot.data['slike']),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.title,color: Theme.of(context).accentColor),
                                title: Text(naslov,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                width: double.infinity,
                                height: 1.0,
                                color: Colors.grey,
                              ),

                              ListTile(
                                leading: Icon(Icons.description,color: Theme.of(context).accentColor),
                                title: Text(snapshot.data['detalji']==null? "Nema detalja o ovom izazovu." : detalji,),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                width: double.infinity,
                                height: 1.0,
                                color: Colors.grey,
                              ),
                              ListTile(
                                leading: Icon(Icons.category,color: Theme.of(context).accentColor),
                                title: Text(snapshot.data['kategorija']),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                width: double.infinity,
                                height: 1.0,
                                color: Colors.grey,
                              ),
                              GestureDetector(
                                onTap: (){//
                                  Navigator.push(context,MaterialPageRoute(
                                      builder: (context) =>Mapa.saPosta(postId,snapshot.data['x'],snapshot.data['y'])));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: (MediaQuery.of(context).size.width * 7)/10,
                                      child: FutureBuilder(
                                        future: Adresa.getAddressFromCoord(snapshot.data['x'],snapshot.data['y']),
                                        builder: (context,snap){
                                          if(snap.data==null)
                                            return Text("Lokacija");
                                          else
                                            return ListTile(
                                              leading: Icon(Icons.location_on,color: Theme.of(context).accentColor,),
                                              title: Text(snap.data,style: TextStyle(color: Theme.of(context).accentColor),),
                                            );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: newPostController,
                          decoration:
                              InputDecoration(
                                labelText: 'Unesite komentar', 
                                labelStyle: TextStyle(color:Theme.of(context).accentColor ),
                                fillColor: Theme.of(context).accentColor,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.add_comment, color: Theme.of(context).accentColor),
                                  onPressed:(_enabledCom==false)?null: () {
                                    setState(() {
                                      _enabledCom=false;
                                    });
                                    dodajKomentar(newPostController.text);
                                  }),
                              ),
                          maxLength: 255,
                          onSubmitted: dodajKomentar,
                        ),
                        ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              primary: false,
                                itemCount: snapshot.data['komentari'] == null ? 0 : snapshot.data['komentari'].length, itemBuilder: (context, index) {
                                  var temp = snapshot.data['komentari'][index];
                                  return Komentar(
                                      temp['userId'],
                                      temp['userImg'],
                                      temp["username"],
                                      temp["text"],
                                      temp["ocena"],
                                      temp['komentarId'],
                                      "post", 
                                      postId,
                                      idKorisnika,
                                      temp['mojaOcena']);
                                }),
                        Padding(
                          padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                        ),
                      ],
                    ),
                  );
                }
              },
            )
            ),
            );
  }

  void dodajKomentar(String text) async {
    var map = Map<String, dynamic>();
    map["KorisnikId"] = idKorisnika;
    map["postId"] = postId;
    map["text"] = newPostController.text;

    if(text.trim()=="")
      return;

    Map<String, String> header = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    var komentar = json.encode(map);
    var res = await http.post("http://147.91.204.116:2048/komentar/dodaj",
        headers: header, body: komentar);

    print(res.statusCode);

    if (res.statusCode == 200) {
      var a = postId;
      var b = idKorisnika;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PostSolution(a, b)));
    } else if(res.statusCode==400) {
      setState(() {
        _enabledCom=true;
      });
      var  data = json.decode(res.body);
      if(data['message']==null){
        showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Greška"),
          content: Container(child: Text("Došlo je do greške. Pokušajte kasnije."),),
        )
        );
      }
      else{
        var datum = new DateFormat('dd.MM.yyyy').format(DateTime.parse(data['message']));
        showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Opomenuti ste"),
         content: Container(child: Text("Administrator aplikacije Moj Grad vas je opomenuo. Do "+datum+" ne možete da dodajete komentare, događaje, izazove i rešenja."),),
        )
        );
      }
      }
      else if(res.statusCode==401){
        showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Greška"),
          content: Container(child: Text("Došlo je do greške. Prijavite se ponovo."),),
        )
        );
        Odjava.OdjaviSe(context);
      
    }
  }
}
