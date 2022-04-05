import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:moj_grad/mapa/mapaApi.dart';
import 'mapaApi.dart';

class Mapa extends StatefulWidget {

  double x,y;
  int id;
  bool param;
  
  Mapa.saPosta(this.id,this.x,this.y){
    param=true;
  }
  Mapa();

  @override
  _MapaState createState() => (param != true) ? _MapaState() : _MapaState.saParametrom(id,x,y);
}

class _MapaState extends State<Mapa> {

  double x,y;
  int id;
  bool parametri;

  _MapaState();
  _MapaState.saParametrom(this.id,this.x,this.y){ parametri=true; trenutnaPozicija=Position(); }

  List<Marker> points;
  List<Marker> dogadjaji;

  Position trenutnaPozicija;
  @override
  void initState() {
    
    MapaAPI.dajPoziciju().then((value) {
      setState(() {
        trenutnaPozicija = value;
      });
        
    });
    MapaAPI.dajMarkere().then((value) {
      setState(() {
        points = value;
      });
      
    });
    MapaAPI.dajMarkereDogadjaja().then((value) {
      setState(() {
        dogadjaji = value;
      });
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prikaz na mapi')),
      body: Stack(
        children: <Widget>[
          Center(
        child: trenutnaPozicija == null
            ? Container(
                height: 65,
                width: 65,
                child: CircularProgressIndicator(),
              )
            : FlutterMap(
                options: MapOptions(
                    center: parametri==true ? LatLng(x,y) : LatLng(trenutnaPozicija.latitude, trenutnaPozicija.longitude),
                    zoom: parametri==true ? 15 : 13),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/makelele/ck81q44bt0bkv1ipdoxe7keu0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFrZWxlbGUiLCJhIjoiY2s4MW16MTM3MHBsYTNkcGd4dnM3cTBqeCJ9.PrmIMEi8Jz4cVhA2FdypjQ",
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoibWFrZWxlbGUiLCJhIjoiY2s4MXBhbTI0MGQ2NTNvbXcybXRobWJldSJ9.yvdXgmt54v_fNTGAVfkZ9w',
                      'id': 'mapbox.mapbox-streets-v8'
                    },
                  ),
                  MarkerLayerOptions(
                    markers: points == null ? [] : points,
                  ),
                  MarkerLayerOptions(
                    markers: dogadjaji==null ? [] : dogadjaji,
                    )
                ],
              ),
      ),
           Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Theme.of(context).primaryColor,),
              
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: 120,
              height: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on,color: Colors.orangeAccent,),
                    Text("Događaji",style: TextStyle(color: Colors.orangeAccent,),)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on,color: Colors.redAccent),
                    Text("Izazovi",style: TextStyle(color: Colors.redAccent,),)
                  ],
                ),
              ],),
            ),
          ),
        ],
      ) 
      /*Center(
        child: trenutnaPozicija == null
            ? Container(
                height: 65,
                width: 65,
                child: CircularProgressIndicator(),
              )
            : FlutterMap(
                options: MapOptions(
                    center: parametri==true ? LatLng(x,y) : LatLng(trenutnaPozicija.latitude, trenutnaPozicija.longitude),
                    zoom: parametri==true ? 15 : 13),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/makelele/ck81q44bt0bkv1ipdoxe7keu0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFrZWxlbGUiLCJhIjoiY2s4MW16MTM3MHBsYTNkcGd4dnM3cTBqeCJ9.PrmIMEi8Jz4cVhA2FdypjQ",
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoibWFrZWxlbGUiLCJhIjoiY2s4MXBhbTI0MGQ2NTNvbXcybXRobWJldSJ9.yvdXgmt54v_fNTGAVfkZ9w',
                      'id': 'mapbox.mapbox-streets-v8'
                    },
                  ),
                  MarkerLayerOptions(
                    markers: points == null ? [] : points,
                  ),
                  MarkerLayerOptions(
                    markers: dogadjaji==null ? [] : dogadjaji,
                    )
                ],
              ),
      ),*/
    );
  }
}