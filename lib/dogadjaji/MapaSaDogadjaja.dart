import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_controller/map_controller.dart';
import 'package:latlong/latlong.dart';

import 'DogadjajDetalji.dart';
import 'DogadjajDetalji.dart';

class MapaSaDogadjaja extends StatefulWidget{
  double x, y;
  int id;

  MapaSaDogadjaja(this.x,this.y,this.id);

  _MapaSaDogadjajaState createState() => _MapaSaDogadjajaState(x,y);
}

class _MapaSaDogadjajaState extends State<MapaSaDogadjaja>{

  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  bool ready = false;

  double x,y;
  List<Marker> point = [];

  @override
  void initState() {
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => setState(() => ready = true));
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    super.initState();
  }

  _MapaSaDogadjajaState(this.x,this.y){
    point.add(Marker(
      width: 45.0,
      height: 45.0,
      point: LatLng(x,y),
      builder: (context) => new Container(
        child: IconButton(
          onPressed: (){
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DogadjajDetalji(widget.id)),
          );
          },
          icon: Icon(Icons.location_on),
          color: Colors.blue,
          iconSize: 45.0,
        ),
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Događaji')),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(this.x,this.y),
          zoom: 17.0,
        ),
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
            markers: point,
          ),
        ],
      ),
    );
  }
}