import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';

class MapaDogadjaj extends StatefulWidget {
  double x;
  double y;

  double izabranaX =0;
  double izabranaY=0;

  MapaDogadjaj(double _x,double _y){
    this.x=_x;
    this.y=_y;
    this.izabranaX=_x;
    this.izabranaY=_y;
  }

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<MapaDogadjaj> {
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  bool ready = false;
  //Position trenutnaPozicija;

  @override
  void initState() {
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => setState(() => ready = true));
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: LatLng(widget.x, widget.y),
             zoom: 17.0,
            ),
            layers: [
              statefulMapController.tileLayer,
              MarkerLayerOptions(
                markers: statefulMapController.markers,
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),

              ),
              onPressed: (){
                widget.izabranaX=mapController.center.latitude;
                widget.izabranaY=mapController.center.longitude;
                print(widget.izabranaX.toString()+" "+widget.izabranaY.toString());
                Navigator.pop(context);
              },
              child: Text("Potvrdi",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Icon(Icons.location_on,size: 35,color: Theme.of(context).accentColor,),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}