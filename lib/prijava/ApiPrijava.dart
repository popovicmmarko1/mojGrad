import 'dart:core';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ApiPrijava {
   static String url = "http://147.91.204.116:2048/izazov";

  static Map<String, String> header = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };

  static Future<String> prijaviProblem(int idKategorije, List<File> images,
      String _naslov, String _opis, double x, double y) async {
    Dio dio = Dio();
    var map = Map<String, dynamic>();

    SharedPreferences p = await SharedPreferences.getInstance();

    try {
      for (var i = 1; i <= images.length; i++) {
        
        List<int> imageData =  images[i - 1].readAsBytesSync();

        var result = await FlutterImageCompress.compressWithList(
          imageData,
          quality: 50
        );
        map['img' + i.toString()] = new MultipartFile.fromBytes(result,
            filename: 'img' + i.toString());
      }
    } catch (e) {
      print("Exception in asset to multipart convert:" + e.toString());
    }

    map['token'] = p.getString('token');
    map['x'] = x;
    map['y'] = y;
    map['idKategorije'] = idKategorije;
    map['naslov'] = _naslov;
    if (_opis != '') map['opis'] = _opis;

    Response<dynamic> rezultat;
    try {
      FormData formData = FormData.fromMap(map);
      //var response = await dio.post(url,data:formData);

      rezultat = await dio.post(
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
      print(rezultat.statusCode.toString());
      if (rezultat.statusCode == 200) return "ok";
      if (rezultat.statusCode == 400) {
        if (rezultat.data['message'] == null) {
          return null;
        }
        var datum = new DateFormat('dd.MM.yyyy')
            .format(DateTime.parse(rezultat.data['message'].toString()));
        return datum;
      }
      if (rezultat.statusCode == 401) return "token";
      return null;
    } catch (e) {
      print("Greska $e");
    }
    return null;
  }
}
