import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:moj_grad/dogadjaji/ApiDogadjaj.dart';
import 'package:moj_grad/dogadjaji/PrikazDogadjaja.dart';
import 'package:moj_grad/dogadjaji/PrikazZainteresovanih.dart';
import 'package:moj_grad/komentar/komentar.dart';
import 'package:moj_grad/odjava/Odjava.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MapaSaDogadjaja.dart';

class DogadjajDetalji extends StatefulWidget {
  final id;
  DogadjajDetalji(this.id);
  @override
  _DogadjajDetaljiState createState() => _DogadjajDetaljiState(id);
}

class _DogadjajDetaljiState extends State<DogadjajDetalji> {
  final int id;
  DateTime odabraniDatum;
  TimeOfDay odabranoVreme;
  bool _enabledCom=false;
  _DogadjajDetaljiState(this.id);
  final String url = "http://147.91.204.116:2048/";
  final Map<String, String> header = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };
  int idKorisnika = 0;
  TextEditingController newPostController = TextEditingController();

  bool zainteresovan;
  Future loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      if (idKorisnika == 0) {
        setState(() {
          idKorisnika = prefs.get("idKorisnika");
        });
      }
    var response =
        await http.get("http://147.91.204.116:2048/dogadjaj/" + id.toString()+"/"+idKorisnika.toString());
    if (response.statusCode == 200) {
      
      return json.decode(response.body);
    }
  }

  void dodajKomentar(String text) async {
    var map = Map<String, dynamic>();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    map["KorisnikId"] = prefs.getInt("idKorisnika");
    map["DogadjajId"] = widget.id;
    map["text"] = text;

    if(text.trim()=="")
      return;

    Map<String, String> header = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    var komentar = json.encode(map);
    var res = await http.post(
        "http://147.91.204.116:2048/komentar/komentarDogadjaj",
        headers: header,
        body: komentar);

    print(res.statusCode);

    if (res.statusCode == 200) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Obaveštenje"),
                content: Container(
                  child: Text("Uspešno ste dodali komentar"),
                ),
              )).then((value) {
        var a = widget.id;
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DogadjajDetalji(a)));
      });
    } else if (res.statusCode == 400) {
      setState(() {
        _enabledCom=true;
      });
      var data = json.decode(res.body);
      if (data['message'] == null) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text("Greška"),
                  content: Container(
                    child: Text("Došlo je do greške. Pokušajte kasnije."),
                  ),
                ));
      } else {
        var datum = new DateFormat('dd.MM.yyyy')
            .format(DateTime.parse(data['message']));
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text("Opomenuti ste"),
                  content: Container(
                    child: Text(
                        "Administrator aplikacije Moj Grad vas je opomenuo. Do " +
                            datum +
                            " ne možete da dodajete komentare, događaje, izazove i rešenja."),
                  ),
                ));
      }
    } else if (res.statusCode == 401) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Greška"),
                content: Container(
                  child: Text("Došlo je do greške. Prijavite se ponovo."),
                ),
              ));
      Odjava.OdjaviSe(context);
    }
  }

  void initState() {
    super.initState();
    ApiDogadjaj.checkZainteresovan(widget.id).then((v) {
      setState(() {
        zainteresovan = v;
      });
    });
  }

  Future<bool> _prijaviEvent(context, String razlog, postId) async {
    var map = Map<String, dynamic>();

    SharedPreferences p = await SharedPreferences.getInstance();

    map['token'] = p.getString("token");
    map['eventId'] = postId;
    map['razlog'] = razlog != '' ? razlog : 'Nije naveden razlog';

    var userJson = json.encode(map);

    try {
      var rezultat = await http.post(url + 'prijava/prijaviDogadjaj',
          headers: header, body: userJson);

      if (rezultat.statusCode == 401) {
        Odjava.OdjaviSe(context);
      }

      return Future.value(rezultat.statusCode == 200 ? true : false);
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> _deleteEvent(context, eventId) async {
    var map = Map<String, dynamic>();

    SharedPreferences p = await SharedPreferences.getInstance();

    map['token'] = p.getString("token");
    map['idEventa'] = eventId;

    var userJson = json.encode(map);

    try {
      var rezultat = await http.post(url + 'dogadjaj/izbrisi',
          headers: header, body: userJson);

      print(rezultat.statusCode);
      if (rezultat.statusCode == 401) {
        Odjava.OdjaviSe(context);
      }

      return Future.value(rezultat.statusCode == 200 ? true : false);
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> _editEvent(context, postId, naslov, opis) async {
    print(odabraniDatum.toString());
    var map = Map<String, dynamic>();
    if (naslov == "") return false;

    SharedPreferences p = await SharedPreferences.getInstance();
    map['naslov'] = naslov;
    map['opis'] = opis;
    map['token'] = p.getString("token");
    map['idEventa'] = id;
    if (odabraniDatum != null) {
      map['datum'] = odabraniDatum.toString();
    }
    if (odabranoVreme != null) {
      final format = DateFormat.jm();
      var vreme =
          new DateTime(1000, 1, 1, odabranoVreme.hour, odabranoVreme.minute);
      map['vreme'] = format.format(vreme);
    }
    var userJson = json.encode(map);

    try {
      var rezultat = await http.post(url + 'dogadjaj/izmeni',
          headers: header, body: userJson);

      print(rezultat.statusCode);
      if (rezultat.statusCode == 401) {
        Odjava.OdjaviSe(context);
      }

      return Future.value(rezultat.statusCode == 200 ? true : false);
    } catch (e) {
      print(e);
    }

    return false;
  }

  void prijava() {
    print("prijava");
    TextEditingController _razlog = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Unesite razlog prijave'),
            content: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _razlog,
              decoration: InputDecoration(hintText: "Razlog prijave"),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () async {
                    var res = await _prijaviEvent(context, _razlog.text, id);

                    if (res) Navigator.of(context).pop();
                  },
                  child: Text(
                    "Prijavi",
                  ))
            ],
          );
        });
  }

  void izmeni(String naslov, String opis) {
    TextEditingController _naslov = TextEditingController();
    _naslov.text = naslov;
    TextEditingController _opis = TextEditingController();
    _opis.text = opis;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _naslov,
                      maxLength: 80,
                      decoration: InputDecoration(hintText: "*Naslov"),
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 255,
                      controller: _opis,
                      decoration: InputDecoration(hintText: "Opis"),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: ListTile(
                        title: Text("Odaberi datum"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: _odaberiDatum,
                      ),
                    ),
                    ListTile(
                      title: Text("Odaberi vreme"),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      onTap: _odaberiVreme,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () async {
                    var res =
                        await _editEvent(context, id, _naslov.text, _opis.text);

                    if (res) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrikazDogadjaja()));
                      //Navigator.pop(context,true);
                    }
                  },
                  child: Text("Izmeni"))
            ],
          );
        });
  }

  _odaberiDatum() async {
    DateTime datum = await showDatePicker(
        context: context,
        initialDate: odabraniDatum == null ? DateTime.now() : odabraniDatum,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5));
    if (datum != null)
      setState(() {
        odabraniDatum = datum;
      });
  }

  _odaberiVreme() async {
    TimeOfDay vreme = await showTimePicker(
      context: context,
      initialTime: odabranoVreme == null ? TimeOfDay.now() : odabranoVreme,
    );
    if (vreme != null) {
      setState(() {
        odabranoVreme = vreme;
      });
    }
  }

  Future<bool> izbrisi() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Vaš post će biti obrisan, da li ste sigurni?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    var res = await _deleteEvent(context, id);

                    if (res) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text("Da")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("Ne")),
            ],
          );
        }).then((value) {
      if (value == true) {
        
        Navigator.pop(context);
        
        Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => PrikazDogadjaja()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Događaj")),
      body: Center(
          child: FutureBuilder(
              future: loadData(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                } else {
                  return Container(
                      padding: EdgeInsets.all(10),
                      child: ListView(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              DateTime.parse(snapshot.data['datum'])
                                  .isAfter(DateTime.now())
                                  ? Container(
                                //alignment: Alignment.topRight,
                                 // margin: EdgeInsets.all(10),
                                  child: RaisedButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(18.0),),
                                      onPressed: () {
                                        ApiDogadjaj.zainteresovan(widget.id)
                                            .then((v) {
                                          if (v == true) {
                                            setState(() {
                                              if (zainteresovan == true) {
                                                zainteresovan = false;
                                              } else {
                                                zainteresovan = true;
                                              }
                                            });
                                          }
                                        });
                                      },
                                      child: zainteresovan == false
                                          ? Text("Zainteresovan",
                                          style: TextStyle(
                                              color: Colors.white))
                                          : Text("Otkaži prisustvo",
                                          style: TextStyle(
                                              color: Colors.white)),
                                      color: zainteresovan == false
                                          ? Theme.of(context).accentColor
                                          : Colors.grey))
                                  : Container(),
                              snapshot.data['userId'] != idKorisnika
                                  ? FlatButton(
                                onPressed: prijava,
                                child: Text(
                                  "Prijavi",
                                  style: TextStyle(
                                      color:
                                      Theme.of(context).accentColor),
                                ),
                              )
                                  : Container(),

                              snapshot.data['userId'] == idKorisnika
                                  ? FlatButton(
                                      onPressed: () {
                                        izmeni(snapshot.data['naslov'],
                                            snapshot.data['opis']);
                                      },
                                      child: Text(
                                        "Izmeni",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['userId'] == idKorisnika
                                  ? FlatButton(
                                      onPressed: () {
                                        izbrisi();
                                      },
                                      child: Text(
                                        "Obriši",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    )
                                  : Container(),
                            ],
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
                                  leading: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              PrikazProfila(
                                                  snapshot.data['userId'])));
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(snapshot.data['userImg']),
                                    ),
                                  ),
                                  trailing: Text(new DateFormat('dd.MM.yyyy').format(DateTime.parse(snapshot.data['datum']))+ " u " + DateFormat('HH:mm ').format(
                                      DateTime.parse(
                                          snapshot.data['datum'])) ,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),),
                                ),
                              ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.title,color: Theme.of(context).accentColor),
                                  title: Text(snapshot.data['naslov'],
                                  style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                  ),
                                )),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  width: double.infinity,
                                  height: 1.0,
                                  color: Colors.grey,
                                ),
                                ListTile(
                                  leading: Icon(Icons.description,color: Theme.of(context).accentColor),
                                  title: Text(snapshot.data['opis'],
                                    ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(maxHeight: 350),
                            child: Image(
                                image: NetworkImage(snapshot.data['slika']),
                                fit: BoxFit.fitHeight),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.all(10),
                                    child: RaisedButton(
                                      shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),),
                                      onPressed: () {
                                        print(snapshot.data['X']);
                                        print(snapshot.data['Y']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MapaSaDogadjaja(
                                                        snapshot.data['x'],
                                                        snapshot.data['y'],
                                                        widget.id)));
                                      },
                                      child: Text("Prikaži na mapi",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      color: Theme.of(context).accentColor,
                                    )),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(18.0),),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PrikazZainteresovanih(id)),
                                      );
                                    },
                                    child: Center(
                                        child: Text("Zainteresovani",
                                            style: TextStyle(
                                                color: Colors.white))),
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                //Expanded(child: RaisedButton(onPressed: (){},child: Text("Zainteresovan"),))
                              ],
                            ),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: newPostController,
                            decoration: InputDecoration(
                                labelText: 'Unesite komentar',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                                fillColor: Theme.of(context).accentColor,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor)),
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
                              itemCount: snapshot.data['komentari'] == null
                                  ? 0
                                  : snapshot.data['komentari'].length,
                              itemBuilder: (context, index) {
                                var temp = snapshot.data['komentari'][index];
                                return Komentar(
                                    temp['userId'],
                                    temp['userImg'],
                                    temp["username"],
                                    temp["text"],
                                    temp["ocena"],
                                    temp['komentarId'],
                                    "event",id,idKorisnika,temp['mojaOcena']);
                              }),
                        ],
                      ));
                }
              })),
    );
  }
}
