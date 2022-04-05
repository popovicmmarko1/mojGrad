import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/post/Post.dart';
import 'package:moj_grad/pretraga/SearchPage.dart';
import 'package:moj_grad/problemi/NisuReseni.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../post/Post.dart';
//import 'BocnaNavigacija.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moj_grad/prijava/ReportProblem.dart';
/*
class ReseniProblemi extends StatefulWidget {
  @override
  _ReseniProblemiState createState() => _ReseniProblemiState();
}

class _ReseniProblemiState extends State<ReseniProblemi> {
  List<Post> postovi = [];
  int idPoslednjeg;
  double x;
  double y;
  int idKorisnika;
  ScrollController sc = new ScrollController();

  @override
  void initState(){
    super.initState();
    idPoslednjeg=0;
    x=1;
    y=1;


    sc.addListener((){
      if(sc.position.pixels==sc.position.maxScrollExtent){
        print(idPoslednjeg.toString());
        fetch();
      }
    });
    fetch();
    
  }

  

  void fetch() async{
    http.Response response;
    SharedPreferences s = await SharedPreferences.getInstance();
    idKorisnika=s.getInt('idKorisnika');
    try{
      response = await http.get("http://10.0.2.2:62054/post/solved/"+x.toString()+"/"+y.toString()+"/"+idPoslednjeg.toString());
    }
    catch(Exception){
      return;
    }

    if(response.statusCode==200){
      var jsonData = json.decode(response.body);
      for(var i in jsonData){


        Post temp = new Post(idKorisnika,i['username'],i['userId'],i['naslov'], i['postId'], i['prvaSlika'],i['slikaResenja'],i['x'],i['y']);
        setState(() {
          postovi.add(temp);
          idPoslednjeg=temp.postId;
        });
      }
    }

  }


  Future<Null> refresh() async{
    setState(() {
      postovi=[];
      idPoslednjeg=0;
    });
    fetch();
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Image.asset('Slike/imageBar.png', fit: BoxFit.cover),
          title: Text("Rešeni izazovi"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                })
          ],
        ),
       floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 60,
            width: 60,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportProblem()),
                );
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: const Alignment(0.7, -0.5),
                    end: const Alignment(0.6, 0.5),
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                ),
                child: Icon(Icons.add_a_photo, size: 30),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            
            children: <Widget>[
              Expanded(
                flex: 1,
                 child: Container(
                   // margin: EdgeInsets.only(left: 20.0),
                    child: IconButton(
                      icon: Icon(Icons.event_busy,color: Colors.red,),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NisuReseni()),
                        );
                      },
                    ),
                  ),
              ),
              Expanded(
                flex: 1,
                //padding: const EdgeInsets.all(8.0),
                child: Container(
                  //margin: EdgeInsets.only(right: 115.0),
                  child: IconButton(
                    icon: Icon(Icons.event_available,color: Colors.green,),
                    onPressed: () {
                     
                    },
                  ),
                ),
              ),
             
            ],
          ),
          color: Theme.of(context).primaryColor,),
        body:postovi.length==0?
        Center(child: CircularProgressIndicator(),):
        RefreshIndicator(
          child: ListView.builder(
              controller: sc,
              itemCount: postovi.length,
              itemBuilder : (BuildContext context,int index){
                
                return postovi[index];
              }
          ),
          onRefresh: refresh,
        ));
  }
}
*/