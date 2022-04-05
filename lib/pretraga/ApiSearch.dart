import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:moj_grad/korisnik/UserPreview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SearchPreview.dart';

class ApiSearch{
  static String Url = "http://147.91.204.116:2048/pretraga/";
  
  static Map<String,String> header= {
    "Content-type":"application/json",
    "Accept":"application/json"
  };

  static Future<List<Widget>> getContent(String value)async{
    List<Widget> lista = [];
    SharedPreferences p =await SharedPreferences.getInstance();
    var map = Map<String,dynamic>();

    map['token']=p.getString('token');
    map['search']=value.trim();

    var jsonMap = jsonEncode(map);

    if(value.length==0)
      return new List();

    try{
      var response = await http.post(Url,headers: header,body: jsonMap);

      if(response.statusCode==200){
        var jsonData = jsonDecode(response.body);
        
        if(jsonData['posts'].length>0)  lista.add(Text("Izazovi", textAlign: TextAlign.center,));
        for(var post in jsonData['posts']){
          var tempPost = new SearchPreview('post',post['naslov'], post['id'],post['slika'],null);
          lista.add(tempPost);
        }

        if(jsonData['users'].length>0) lista.add(Text("Korisnici", textAlign: TextAlign.center,));
        for(var user in jsonData['users']){
          var tempUser = new UserPreview(user['username'], user['ime'], user['prezime'], user['id'], user['slika']);
          lista.add(tempUser);
        }

        if(jsonData['events'].length>0) lista.add(Text("Događaji", textAlign: TextAlign.center,));
        for(var event in jsonData['events']){
          event['datum']=new DateFormat('dd.MM.yyyy').format(DateTime.parse(event['datum']));
          var tempEvent = new SearchPreview('event',event['naslov'], event['id'],event['slika'],event['datum']);
          lista.add(tempEvent);
        }
      }
    }catch(e){
      print(e);
    }
    
    return lista;
  }

}