import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:moj_grad/korisnik/UserPreview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiDogadjaj{
  static String url = "http://147.91.204.116:2048/Dogadjaj";
  static Map<String, String> header={
    "Content-type" : "application/json",
    "Accept" : "application/json"
  };

  static Future<String> napravi(String token,String _naziv,String _opis,String datum,String vreme,String image,double x,double y) async{
    var map = Map<String, dynamic>();

    map['token'] = token;
    map['datum'] = datum;
    map['vreme'] = vreme;
    map['opis'] = _opis;
    map['naslov'] = _naziv;
    map['x'] = x;
    map['y'] = y;
    map['slika'] = image;


    var userJson = json.encode(map);
    
    var rezultat = await http.put(url,headers: header,body: userJson);
    print(rezultat.statusCode.toString());
    if(rezultat.statusCode==200) return "ok";
    if(rezultat.statusCode==400){
      var data = json.decode(rezultat.body);
      if(data['message']==null) return null;
      var datum = new DateFormat('dd.MM.yyyy').format(DateTime.parse(data['message']));
      return datum;
    }
    if(rezultat.statusCode==401) return "token";
    return null;
    
  }

  static Future<bool> zainteresovan(int id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();

    map['token'] = prefs.getString('token');
    map['idEventa']=id;
    
    var userJson = json.encode(map);

    var rezultat = await http.post(url+"/zainteresovan",headers: header,body: userJson);

    return Future.value(rezultat.statusCode == 200 ? true : false);
  }

  static Future<bool> checkZainteresovan(int id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();

    map['token'] = prefs.getString('token');
    map['idEventa']=id;
    var userJson = json.encode(map);

    var rezultat = await http.post(url+"/proverazainteresovan",headers: header,body: userJson);

    return Future.value(rezultat.statusCode == 200 ? true : false);
  }


  static Future<List<UserPreview>> prikazZainteresovanih(int id)async {
    var map = Map<String, dynamic>();

    
    List<UserPreview> lista = [];
    map['idEventa']=id;

    var userJson = json.encode(map);
    
    var rezultat = await http.post(url+"/dajZainteresovane",headers: header,body: userJson);
    if(rezultat.statusCode!=200) return lista;
    var data = json.decode(rezultat.body);
    for(var i in data){
      var temp = new UserPreview(i['username'], i['ime'], i['prezime'], i['id'], i['slika']);
      lista.add(temp);
    }
    return lista;

  }
}