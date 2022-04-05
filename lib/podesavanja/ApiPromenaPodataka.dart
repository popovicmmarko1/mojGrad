import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiPromenaPodataka {
  static String urlSlika = "http://147.91.204.116:2048/profil/promeniSliku";
  static String urlRadius = "http://147.91.204.116:2048/profil/promeniUdaljenost";
  static String urlIme = "http://147.91.204.116:2048/profil/promeniKorisnickoIme";
  static String urlBio = "http://147.91.204.116:2048/profil/promeniBiografiju";
  static String urlSifra = "http://147.91.204.116:2048/profil/promeniLozinku";

  static Map<String, String> header={
    "Content-type" : "application/json",
    "Accept" : "application/json"
  };

  static Future<bool> promeniSliku(String token,String image) async{
    var map = Map<String, dynamic>();

    map["token"] = token;
    map["image"] = image;


    var userJson = json.encode(map);

    var rezultat = await http.post(urlSlika,headers: header,body: userJson);

    if(rezultat.statusCode==200){
      print("uspesno");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var data = json.decode(rezultat.body);
      preferences.setString("image", data['image']);
      return true;
    }
    return false;
  }

  static Future<bool> promeniPoluprecnik(String token,double vrednost) async{
    var map = Map<String, dynamic>();
    map["token"]=token;
    map["radius"]=vrednost;

    var userJson = json.encode(map);


    var rezultat = await http.post(urlRadius,headers: header,body: userJson);
    print(rezultat.statusCode);
    return Future.value(rezultat.statusCode == 200 ? true : false);

  }

  static Future<bool> promeniPass(String token,String old,String pass) async{
    var map = Map<String, dynamic>();

    map["token"] = token;
    map["oldPassword"] = old;
    map["password"] = pass;




    var userJson = json.encode(map);

    var rezultat = await http.post(urlSifra,headers: header,body: userJson);
    print(rezultat.statusCode);
    return Future.value(rezultat.statusCode == 200 ? true : false);

  }

  static Future<bool> promeniIme(String token,String name) async{
    var map = Map<String, dynamic>();

    map["token"] = token;
    map["username"] = name;

    var userJson = json.encode(map);

    var rezultat = await http.post(urlIme,headers: header,body: userJson);
    print(rezultat.statusCode);

    if(rezultat.statusCode==200){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var data = json.decode(rezultat.body);
      preferences.setString("username", data['username']);
      return true;
    }
    return false;
    //fali za 401 i 400 da kaze da postoji
  }

  static Future<bool> promeniBio(String token,String bio) async{
    var map = Map<String, dynamic>();

    map["token"] = token;
    map["bio"] = bio;

    var userJson = json.encode(map);

    var rezultat = await http.post(urlBio,headers: header,body: userJson);
    print(rezultat.statusCode);

    if(rezultat.statusCode==200){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //var data = json.decode(rezultat.body);
      preferences.setString("bio", bio);
      return true;
    }
    return false;
    //fali za 401 i 400 da kaze da postoji
  }
}