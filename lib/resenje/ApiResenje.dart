import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ApiResenje{
  
  static String url = "http://147.91.204.116:2048/resenje/dodaj";
  
  static String urlOceni = "http://147.91.204.116:2048/resenje/oceni";
  
   static Map<String, String> header={
    "Content-type" : "application/json",
    "Accept" : "application/json"
  };
  
  static Future<String> dodajResenje(List<File> images,String _opis,int idPosta) async{
    Dio dio = Dio();
    var map = Map<String, dynamic>();

    SharedPreferences p = await SharedPreferences.getInstance();
    
    try{
      for(var i=1;i<=images.length;i++){
        List<int> imageData = images[i-1].readAsBytesSync();
        var result = await FlutterImageCompress.compressWithList(
          imageData,
          quality: 50,
        );
        map['img'+i.toString()]=new MultipartFile.fromBytes(result,filename: 'img'+i.toString());
      }
    }catch (e){
      print("Exception in asset to multipart convert:"+e.toString());
    }
    map['idPosta']= idPosta;
    map['token']=p.getString('token');
      print(map['token']);
      if(_opis != '')
        map['opis']=_opis;
        
      try{
        FormData formData = FormData.fromMap(map);
        //var response = await dio.post(url,data:formData);

         var rezultat =await dio.post(
          url,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
            //headers: headers,
          ),
        );
        if(rezultat.statusCode==200) return "ok";
        if(rezultat.statusCode==400){
          if(rezultat.data['message']==null)
          {
            return null;
          } 
          var datum = new DateFormat('dd.MM.yyyy').format(DateTime.parse(rezultat.data['message'].toString()));
          return datum;
        }
        if(rezultat.statusCode==401) return "token";
        return null;
        

      }
      catch (e){
        print("Greska $e");
      }
      return null;
    }
  
 
  static Future<bool> oceni(int idResenja,int ocena) async {
    var map = Map<String, dynamic>();
      
      SharedPreferences p = await SharedPreferences.getInstance();
      map["idResenja"]= idResenja;
      map["token"]=p.getString('token');
      map["ocena"]=ocena;

      var jsonEncoded = json.encode(map);

      var res = await http.post(urlOceni,body: jsonEncoded,headers: header);
     // print(res.toString());
      return res.statusCode==200?true:false;

  }
}