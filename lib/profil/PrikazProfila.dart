import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:moj_grad/dogadjaji/DogadjajPreview.dart';
import 'package:moj_grad/podesavanja/PromenaPodataka.dart';
import 'package:moj_grad/post/Post.dart';
import 'HeaderProfila.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrikazProfila extends StatefulWidget {
  int id;

  PrikazProfila(this.id);

  @override
  _PrikazProfilaState createState() => _PrikazProfilaState(id);
}

class _PrikazProfilaState extends State<PrikazProfila>
    with TickerProviderStateMixin {
  int id;
  List<Widget> listContent = List<Widget>();
  List<Widget> listPosts = List<Widget>();
  List<Widget> listEvents = List<Widget>();

  String url ='http://147.91.204.116:2048/profil/';

  _PrikazProfilaState(this.id);

  Future<String> getUsername() async {
    var username = await http.get(Uri.encodeFull(url + 'korisnickoIme/' + id.toString()));

    String user = "";
    if (username.statusCode == 200) {
      var data = json.decode(username.body);
      user = data['username'];
    }
    return user;
  }

  Future<Widget> getHeaderAndData() async {

    try{
      var response = await http.get(Uri.encodeFull(url + 'header/' + id.toString()));
      
      HeaderProfila header;
      if (response.statusCode == 200) {
        var headerData = json.decode(response.body);
      
        //headerData['image'] =headerData['image'].replaceAll('10.0.2.2:62054', '192.168.1.5:45455');
        header = new HeaderProfila(
            headerData['id'],
            headerData['image'],
            headerData['poeni'],
            headerData['bio'] == null ? "" : headerData['bio'],
            headerData['imePrezime']);
        return header;
      }
   }
   catch(e){
     print(e);
   }

    return null;
  }

  Future<List<Widget>> getResenja() async {
    var postsReq = await http.get(Uri.encodeFull(url + 'resenja/' + id.toString()));

    SharedPreferences p = await SharedPreferences.getInstance();
    int idKorisnika = p.getInt('idKorisnika');

    List<Widget> listaPostova = [];

    if (postsReq.statusCode == 200) {
      var postoviData = json.decode(postsReq.body);

      for (var post in postoviData) {
        Post p = new Post(idKorisnika, post['username'], post['userId'],post['naslov'], post['postId'], post['prvaSlika'],post['slikaResenja'],post['x'],post['y'],post['userImg']);
        listaPostova.add(p);
      }
    }
	return listaPostova;
  }

  Future<List<Widget>> getPosts() async {
    var postsReq = await http.get(Uri.encodeFull(url + 'izazovi/' + id.toString()));

    SharedPreferences p = await SharedPreferences.getInstance();
    int idKorisnika = p.getInt('idKorisnika');

    List<Widget> listaPostova = [];

    if (postsReq.statusCode == 200) {
      var postoviData = json.decode(postsReq.body);

      for (var post in postoviData) {
        Post p = new Post(idKorisnika, post['username'], post['userId'],post['naslov'], post['postId'], post['prvaSlika'],post['slikaResenja'],post['x'],post['y'],post['userImg']);
        listaPostova.add(p);
      }
    }

    
	return listaPostova;
  }

  Future<List<Widget>> getEvents() async {

    List<Widget> list = [];

    try {
      var response = await http.get(Uri.encodeFull(url + 'dogadjaji/' + id.toString()));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        for (var e in jsonData) {
          var datum =
              new DateFormat('dd.MM.yyyy').format(DateTime.parse(e['datum']));
          var vreme =
              new DateFormat('HH:mm ').format(DateTime.parse(e['datum']));
          
          DogadjajPreview temp = new DogadjajPreview(
              e['idEventa'],
              e['idKorisnika'],
              e['username'],
              e['userImg'],
              e['naslov'],
              e['eventImg'],
              datum,
              vreme,
              e['x'],
              e['y']);
          list.add(temp);
        }
      }
    } catch (e) {
      print(e);
    }
	return list;
  }

  Future<List<Widget>> getAch() async{
    List<Widget> lista = List<Widget>();

    try{
      var response = await http.get(Uri.encodeFull(url +'medalje/' + id.toString()));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        for(var i in jsonData){

          lista.add(Container(
          child: Row(
            children: <Widget>[
              Image.network(i['slika'], width: MediaQuery.of(context).size.width /3,),
              Expanded(child: Column(
                children: <Widget>[
                  Text(i['opis']),
                  Text(new DateFormat('dd.MM.yyyy').format(DateTime.parse(i['datum']))+" ")
                ],
              ))
            ],
          ),
        ));

        }
      }
    }catch(e){
      print(e);
    }

    return lista;
  }

  TabController _tabController;

  int idKorisnika;

  loadKorisnik()async{
    SharedPreferences p = await SharedPreferences.getInstance();
    idKorisnika=p.getInt('idKorisnika');
    if(idKorisnika==id)
      return idKorisnika;
    else return null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                FutureBuilder(
                  future: loadKorisnik(),
                  builder: (BuildContext context, AsyncSnapshot snap){
                  if(snap.data==null)
                    return Container();
                  else return IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PromeniPodatke()),
                    );
                  });
                })
              ],
              title: FutureBuilder(
                future: getUsername(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Text("Korisnik");
                  } else {
                    return Text(snapshot.data);
                  }
                },
              ),
            ),
            SliverFillRemaining(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: getHeaderAndData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Theme.of(context).appBarTheme.textTheme.title.color
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return snapshot.data;
                      }
                    },
                  ),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).accentColor,
                    labelColor: Theme.of(context).appBarTheme.textTheme.title.color,
                    labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    tabs: <Widget>[
                      new Tab(
                        child: FutureBuilder(
                          future: getResenja(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Text("Rešenja ");
                            else
                              return Text("Rešenja " +
                                  snapshot.data.length.toString());
                          },
                        ),
                      ),
                      new Tab(
                        child: FutureBuilder(
                          future: getPosts(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Text("Izazovi");
                            else
                              return Text(
                                  "Izazovi " + snapshot.data.length.toString());
                          },
                        ),
                      ),
                      new Tab(
                        child: FutureBuilder(
                          future: getEvents(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Text("Događaji");
                            else
                              return Text("Događaji " +
                                  snapshot.data.length.toString());
                          },
                        ),
                      ),
                      new Tab(
                        child:Icon(Icons.stars)
                        /* FutureBuilder(
                          future: getAch(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Text("Dostignuća ");
                            else
                              return Text("Dostignuća " +
                                  snapshot.data.length.toString());
                          },
                        ),*/
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        FutureBuilder(
                          future: getResenja(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null || snapshot.data.length==0)
                              return Image.asset('Slike/nijeResavao.png');
                            else
                              return ListView.builder(
                                  //physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  primary: false,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return snapshot.data[index];
                                  });
                          },
                        ),
                        FutureBuilder(
                          future: getPosts(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null || snapshot.data.length==0)
                              return Image.asset('Slike/nijeObjavljivao.png');
                            else
                              return ListView.builder(
                                  //physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  primary: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return snapshot.data[index];
                                  });
                          },
                        ),
                        FutureBuilder(
                          future: getEvents(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null || snapshot.data.length==0)
                              return Image.asset('Slike/nijeObljavljivaoDog.png');
                            else
                              return ListView.builder(
                                  //physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  primary: false,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return snapshot.data[index];
                                  });
                          },
                        ),
                        FutureBuilder(
                          future: getAch(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Container();
                            else
                              return ListView.builder(
                                  //physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  primary: false,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return snapshot.data[index];
                                  });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
