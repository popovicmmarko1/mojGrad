import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:moj_grad/dogadjaji/PrikazDogadjaja.dart';
import 'package:moj_grad/grafik/Grafik.dart';
import 'package:moj_grad/mapa/mapaApi.dart';
import 'package:moj_grad/post/Post.dart';
import 'package:moj_grad/pretraga/SearchPage.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moj_grad/podesavanja/ApiPromenaPodataka.dart';
import '../post/Post.dart';
import 'BocnaNavigacija.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moj_grad/prijava/ReportProblem.dart';

class PocetnaStrana extends StatefulWidget {
  @override
  _PocetnaStranaState createState() => _PocetnaStranaState();
}

class _PocetnaStranaState extends State<PocetnaStrana> {
  List<Post> postovi;
  int idPoslednjeg;
  int idKorisnika;
  bool hasNext=true;
  double rating;
  String message = "";


  int vrednostRadio=0;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
  ScrollController sc = new ScrollController();
  @override
  void initState(){
    super.initState();
   
    idPoslednjeg=0;

    loadKorisinik();
    loadPoluprecnik();

    
    /*sc.addListener((){
      if(sc.position.pixels==sc.position.maxScrollExtent){
        print(idPoslednjeg.toString());
        fetch();
      }
    });*/
    fetch();
  }

  void loadPoluprecnik() async{
    SharedPreferences s = await SharedPreferences.getInstance();
    rating = s.getDouble('radius');
    message =
    " Izabrana udaljenost ${rating.toStringAsFixed(1)} km.";
  }

  void loadKorisinik()async{
    SharedPreferences s = await SharedPreferences.getInstance();
    idKorisnika=s.getInt('idKorisnika');

  }

  void fetch() async{
    http.Response response;
    SharedPreferences s = await SharedPreferences.getInstance();
    var pozicija = await MapaAPI.dajPoziciju();


    var resenjaInd;
    if(vrednostRadio==0)
      resenjaInd="";
    else if(vrednostRadio==1)
      resenjaInd="reseni/";
    else
      resenjaInd='nereseni/';

    try{
      response = await http.get("http://147.91.204.116:2048/izazov/"+ resenjaInd +pozicija.latitude.toString()+"/"+pozicija.longitude.toString()+"/"+idPoslednjeg.toString()+"/"+s.getDouble("radius").toString());
    }
    catch(Exception){
      return;
    }
    print(response.statusCode.toString());
    if(response.statusCode==200){
      if(postovi==null){
        setState(() {
        postovi=[];
      });
      }
      var jsonData = json.decode(response.body);
      print(jsonData.length.toString());
      if(jsonData.length<5){
        setState(() {
          hasNext=false;
        });
      }
      for(var i in jsonData){
        Post temp = new Post(idKorisnika,i['username'],i['userId'],i['naslov'], i['postId'], i['prvaSlika'],i['slikaResenja'],i['x'],i['y'],i['userImg']);
        setState(() {
          postovi.add(temp);
          idPoslednjeg=temp.postId;  
        });
      }
      
    }
    
  }


  Future<Null> refresh() async{
    setState(() {
      postovi=null;
      idPoslednjeg=0;
      hasNext=true;
    });
    fetch();
    return null;
  }

  filtriraj(){
    showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<int>(
                    title: Text("Prikaži sve"),
                    value: 0,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: vrednostRadio,
                    onChanged: (int value) {
                      setState(() => vrednostRadio = value);
                      Navigator.pop(context,true);
                    },
                  ),
                  RadioListTile<int>(
                    title: Text("Samo rešeni"),
                    value: 1,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: vrednostRadio,
                    onChanged: (int value) {
                      setState(() => vrednostRadio = value);
                      Navigator.pop(context,true);
                    },
                  ),
                  RadioListTile<int>(
                    title: Text("Samo nerešeni"),
                    value: 2,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: vrednostRadio,
                    onChanged: (int value) {
                      setState(() => vrednostRadio = value);
                      Navigator.pop(context,true);
                    },
                  ),
                  Container(
                    //linija izmedju teme i okruženja
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Širina okruženja"),
                            Slider(
                              value: rating,
                              onChanged:(double e){
                                setState(() {
                                rating = e;
                                print(e);
                                message = " Izabrana udaljenost ${e.toStringAsFixed(1)} km.";
                                });
                                },
                              label: rating.toString(),
                              min: 1,
                              max: 100,
                              activeColor:
                              Theme.of(context).accentColor,
                              inactiveColor: Colors.grey,
                            ),
                            Text(message),
                          ],
                        )),
                    trailing: Icon(Icons.check),
                    onTap: () {
                      promeniPoluprecnik(rating);
                    },
                  )
                ],
              ),
            );
          },
        ),
      );
    }
    ).then((value){
      if(value==true)
        refresh();
    });
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Izazovi u blizini"),
          actions: <Widget>[
             IconButton(icon: Icon(Icons.filter_list),
              onPressed: () {
                filtriraj();
              }),
          IconButton(icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              }),
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
                ).then((value) {
                  if(value==true ){
                    refresh();
                  }
                });
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.white, width: 4),
                  shape: BoxShape.circle,
                  color: Theme.of(context).appBarTheme.textTheme.title.color
                ),
                child: Icon(Icons.add_a_photo, size: 30, color: Theme.of(context).primaryColor,),
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
                      icon: Icon(Icons.event),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazDogadjaja()),);
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
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazProfila(idKorisnika)));
                    },
                  ),
                ),
              ),
             
            ],
          ),
          color: Theme.of(context).appBarTheme.color,
          
        ),
        drawer: BocnaNavigacija(),
        
        body:postovi==null?
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
          child: postovi.length>0? 
          InfiniteListView(
            itemBuilder: (context, index){
              return postovi[index];
            }, 
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: postovi.length, 
            nextData: fetch,
            hasNext: hasNext==true,
            ):SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(), child: Column(children: <Widget>[Container(height:MediaQuery.of(context).size.height, alignment: Alignment.center, child: Text("Još uvek nema izazova u vašoj blizini",style: TextStyle(color:Theme.of(context).accentColor),),)],),),
          onRefresh: refresh,
        ));
  }

  void promeniPoluprecnik(double vrednost) async {
    print(vrednost);

    String token;

    SharedPreferences p = await SharedPreferences.getInstance();
    token = p.getString("token");
    p.setDouble('radius', vrednost);

    var rezultat = await ApiPromenaPodataka.promeniPoluprecnik(token, vrednost);
    if (rezultat == true) {
      print("uspesno promenjen poluprecnik");
      Navigator.pop(context,true);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greska"),
              content: Text("Doslo je do greške, pokušajte ponovo"),
            );
          });
    }
  }

}