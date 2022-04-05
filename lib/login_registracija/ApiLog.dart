import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api{
  static String logovanjeUrl = "http://147.91.204.116:2048/Korisnik";
  static Map<String,String> header= {
    "Content-type":"application/json",
    "Accept":"application/json"
  };

  static Future<bool> proveriUsera(String username,String password,String fcmToken) async{
    var map = Map<String,String>();
    map["Username"]=username;
    map["Password"]=password;
    map["fcmToken"] = fcmToken;

    var userJson=json.encode(map);
    try{
      var rezultat=await http.post(logovanjeUrl,headers:header,body: userJson);
      if(rezultat.statusCode==200){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var data = json.decode(rezultat.body);
        
        preferences.setInt("idKorisnika", data['id']);
        preferences.setString("token", data['token']);
        preferences.setString("image", data['img']);
        preferences.setString("bio", data['bio']);
        preferences.setString("username", data['username']);
        preferences.setString("imePrezime", data['imePrezime']);
        preferences.setDouble("radius",data["radius"]+0.0);
        preferences.setBool('themeBool', false);
        return true;
      }
    }
    catch(e){
        print(e);
    }
    return false;
  }

  static Future<String> registrujSe(String ime,String prezime,String username,String password,String email,String fcmToken)async {
    var map = Map<String, String>();
    map["Username"] = username;
    map["Password"] = password;
    map["Ime"] = ime;
    map["Prezime"] = prezime;
    map["Email"] = email;
    map["fcmToken"] = fcmToken;

    try{
      var userJson = json.encode(map);
      var rezultat = await http.post(logovanjeUrl, headers: header, body: userJson);
      if(rezultat.statusCode==200){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var data = json.decode(rezultat.body);
        preferences.setInt("idKorisnika", data['id']);
        preferences.setString("token", data['token']);
        preferences.setString("image", data['img']);
        preferences.setString("username", data['username']);
        preferences.setString("bio", data['bio']);
        preferences.setString("imePrezime", data['imePrezime']);
        preferences.setDouble("radius", 10 + 0.0);
        preferences.setBool('themeBool', false);
        return "ok";
      }
      else if(rezultat.statusCode==400){
        var data = json.decode(rezultat.body);
        if(data['msg']=="email")
        {
          return "email";
        }
        if(data['msg']=="username")
        {
          return "username";
        }
        else return null;
      }
      
    }
    catch(e){
      print(e);
    }
    return null;
  }
  }
