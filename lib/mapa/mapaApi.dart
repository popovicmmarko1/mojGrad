import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:moj_grad/dogadjaji/DogadjajDetalji.dart';
import 'package:moj_grad/post/PostSolution.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapaAPI {
  static String url = 'http://147.91.204.116:2048/mapa';

  static Future<List<Marker>> dajMarkere([requestedId]) async {

    SharedPreferences p = await SharedPreferences.getInstance();
    int idKorisnika=p.getInt('idKorisnika');

    List<Marker> points = List<Marker>();
    
    var response = await http.get(url, headers: {'Accept': 'application/json'});
    //print(response.body);
    var extractData = json.decode(response.body);

    for (int i = 0; i < extractData.length; i++) {
      points.add(
        Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(extractData[i]['x'], extractData[i]['y']),
          builder: (context) => new Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: ( requestedId != null && requestedId==extractData[i]['id'])? Colors.blue : Colors.redAccent,
              iconSize: 45.0,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) =>PostSolution(extractData[i]['id'],idKorisnika)));
              },
            ),
          ),
        ),
      );
    }
    return points;
  }

  static Future<List<Marker>> dajMarkereDogadjaja() async {

    SharedPreferences p = await SharedPreferences.getInstance();
    int idKorisnika=p.getInt('idKorisnika');

    List<Marker> points = List<Marker>();
    
    var response = await http.get(url+"/dogadjaji", headers: {'Accept': 'application/json'});
    print(response.body);
    var extractData = json.decode(response.body);

    for (int i = 0; i < extractData.length; i++) {
      points.add(
        Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(extractData[i]['x'], extractData[i]['y']),
          builder: (context) => new Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.orangeAccent,
              iconSize: 45.0,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) =>DogadjajDetalji(extractData[i]['id'])));
              },
              
            ),
          ),
        ),
      );
    }
    return points;
  }

  static Future<Position> dajPoziciju() async {
    Position trenutnaPozicija;
    print("trazim Lokaciju");
    trenutnaPozicija = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print("nasao lokaciju");
    return trenutnaPozicija;
  }
}
