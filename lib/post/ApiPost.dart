import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moj_grad/odjava/Odjava.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiPost{
  static String url = "http://147.91.204.116:2048/";
  //static String url = "http://192.168.1.5:45455/";
  static Map<String,String> header= {
    "Content-type":"application/json",
    "Accept":"application/json"
  };


  static Future<bool> editPost(context,postId,naslov,opis)async{
    var map = Map<String, dynamic>();
    if(naslov=="")
      return false;

    SharedPreferences p = await SharedPreferences.getInstance();
    map['naslov']=naslov;
    map['opis']=opis;
    map['token']=p.getString("token");
    map['idPosta']=postId;

    var userJson = json.encode(map);

    try{
      var rezultat = await http.post(url+'izazov/izmeni', headers: header, body: userJson);

      print(rezultat.statusCode);
      if(rezultat.statusCode == 401){
        Odjava.OdjaviSe(context);
      }
        
      return Future.value(rezultat.statusCode == 200 ? true : false);
    }
    catch(e){
      print(e);
    }

    return false;
  }

  static Future<bool> deletePost(context,postId)async{
    var map = Map<String, dynamic>();

    SharedPreferences p = await SharedPreferences.getInstance();

    map['token']=p.getString("token");
    map['idPosta']=postId;

    var userJson = json.encode(map);

    try{
      var rezultat = await http.post(url+'izazov/izbrisi', headers: header, body: userJson);

      print(rezultat.statusCode);
      if(rezultat.statusCode == 401){
        Odjava.OdjaviSe(context);
      }

      return Future.value(rezultat.statusCode == 200 ? true : false);
    }catch(e){
      print(e);
    }
    return false;
  }

  static Future<bool> prijaviPost(context,String razlog,postId)async{
    var map = Map<String, dynamic>();

    SharedPreferences p = await SharedPreferences.getInstance();

    map['token']=p.getString("token");
    map['postId']=postId;
    map['razlog']= razlog != '' ? razlog : 'Nije naveden razlog!';

    var userJson = json.encode(map);

    try{
      var rezultat = await http.post(url+'prijava/prijaviIzazov', headers: header, body: userJson);

      if(rezultat.statusCode == 401){
        Odjava.OdjaviSe(context);
      }

      return Future.value(rezultat.statusCode == 200 ? true : false);
    }catch(e){
      print(e);
    }

    return false;
  }

}