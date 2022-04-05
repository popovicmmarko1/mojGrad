import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Kategorija{
  String naziv;
  int id;

  Kategorija(this.id, this.naziv);

  static Future<List<Kategorija>> getKategorije() async {

    var response = await http.get(Uri.encodeFull('http://147.91.204.116:2048/kategorija')); 

    //var response = await http.get(Uri.encodeFull('http://192.168.1.4:45455/kategorija'));

    List<Kategorija> lista = [];
    if(response.statusCode==200)
    {
      var data = json.decode(response.body);

      for(var d in data)
      {
        lista.add(new Kategorija(d['id'], d['naziv']));
      }
    }
    return lista;
  }
}