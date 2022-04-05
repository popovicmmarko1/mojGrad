import 'package:geocoder/geocoder.dart';

class Adresa{

  static Future<String> getAddressFromCoord(x,y)async{
    String place;
    
    if(x==-1 || y==-1)
      return null;
      
    try{
      var results = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(x,y));
      var first=results.first;
      
      place=first.addressLine;

    }catch(e){
      print(e);
    }

    return place;
  }

}