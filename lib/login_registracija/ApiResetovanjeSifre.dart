import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResetovanjeSifre {
  static String resetUrl = "http://147.91.204.116:2048/korisnik/resetujLozinku";
  static Map<String, String> header = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };

  static Future<bool> resetujPass(String podatak) async{
    var map = Map<String,String>();

    String proveraEmail = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";

    RegExp regExp = new RegExp(proveraEmail);
    if(!(regExp.hasMatch(podatak))){
      map['Username']=podatak;
      //print("ime");
    }
    else{
      map['Email']=podatak;
     // print("mejl");
    }


    var userJson=json.encode(map);
    var rezultat=await http.post(resetUrl,headers:header,body: userJson);
    print(rezultat.statusCode);
    return Future.value(rezultat.statusCode == 200 ? true : false);
  }
}