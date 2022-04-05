import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/adresa/Adresa.dart';
import 'package:moj_grad/dogadjaji/PrikazDogadjaja.dart';
import 'package:moj_grad/odjava/Odjava.dart';
import 'package:moj_grad/prijava/FullSizeImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mapa/mapaApi.dart';
import 'ApiDogadjaj.dart';
import 'MapaDogadjaj.dart';


class NapraviDogadjaj extends StatefulWidget {

  DateTime datum;
  NapraviDogadjaj(DateTime datum){
    this.datum = datum;
  }


  @override
  _NapraviDogadjajState createState() => _NapraviDogadjajState();
}

class _NapraviDogadjajState extends State<NapraviDogadjaj>{
  DateTime odabraniDatum;
  TimeOfDay odabranoVreme;
  File _image;
  String token = '';
  bool _isEnabled=true;
  String lokacijaText = "Uključite lokaciju na vašem uređaju.";
  double izabranoX;
  double izabranoY;

  static final TextEditingController _naziv = new TextEditingController();
  static final TextEditingController _opis = new TextEditingController();


  String get getNaziv => _naziv.text;
  String get getOpis => _opis.text;
  

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    SharedPreferences p = await SharedPreferences.getInstance();
    data['username'] = p.getString("username");
    data['image'] = p.getString("image");
    data['id'] = p.getInt("idKorisnika");
    data['imePrezime'] = p.getString("imePrezime");
    data['token'] = p.getString("token");
    return data;
  }

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: FutureBuilder(
        future: getData(),
    builder: (context, AsyncSnapshot snapshot){
          if(snapshot.data==null){
            return Container(
              child: CircularProgressIndicator(),
            );
          }
          else {
            token = snapshot.data['token'];
            return Scaffold(
              appBar: AppBar(
                title: Text("Kreiranje događaja"),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        controller: _naziv,
                        maxLength: 80,
                        decoration: InputDecoration(
                            hintText: "Naziv događaja ",
                            fillColor: Theme.of(context).accentColor,
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(32.0)),
                                borderSide: BorderSide(color: Theme.of(context).accentColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 255,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        controller: _opis,
                        decoration: InputDecoration(
                            hintText: "Opis događaja ",
                            fillColor: Theme.of(context).accentColor,
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(32.0)),
                                borderSide: BorderSide(color: Theme.of(context).accentColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                    ),
                    ListTile(
                      title: Text("Datum ${widget.datum.day}.${widget.datum
                          .month}.${widget.datum.year}"),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      onTap: _odaberiDatum,
                    ),
                    ListTile(
                      title: Text("Vreme ${odabranoVreme.hour}:${odabranoVreme
                          .minute}"),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      onTap: _odaberiVreme,
                    ),
                    Padding(
                      padding:  EdgeInsets.all(10.0),
                      child: lokacijaText!=null ? Text(lokacijaText) : Text("Uključite lokaciju na vašem uređaju."),
                    ),
                    new RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: izaberiLokaciju,
                      child: new Text('Izaberite drugu lokaciju', style: TextStyle(color: Colors.white),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: _imageView(),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.check,color: Colors.white),
                  backgroundColor: Theme.of(context).accentColor,
                  onPressed: _isEnabled!=true? null : () {
                    setState(() {
                      _isEnabled=false;
                    });
                    _submit();
                  }
              ),
            );
          }
        }
    ));

  }
  _odaberiDatum() async {
    DateTime datum = await showDatePicker(context: context,
        initialDate: widget.datum,
        firstDate: DateTime(DateTime
            .now()
            .year),
        lastDate: DateTime(DateTime
            .now()
            .year + 5)
    );

    /*if (widget.datum != null) {
      datum = widget.datum;
      setState(() {
        odabraniDatum = datum;
      });
    }*/
    //else {
      if (datum != null)
        setState(() {
          odabraniDatum = datum;
          widget.datum = odabraniDatum;
         // print(odabraniDatum);
        });
    //}
  }




  @override
  void initState() {
    super.initState();
    odabraniDatum = DateTime.now();
    odabranoVreme = TimeOfDay.now();
    MapaAPI.dajPoziciju().then((p)async{
      trenutnaX=p.latitude;
      trenutnaY=p.longitude;

      izabranoX = trenutnaX;
      izabranoY = trenutnaY;

      if(trenutnaX!=null && trenutnaY!=null){
        izabranoX=trenutnaX;
        izabranoY=trenutnaY;
        var lokacija=await Adresa.getAddressFromCoord(trenutnaX, trenutnaY);
        setState(() {
          lokacijaText=lokacija;
        });
      }
    });
  }

  double trenutnaX;
  double trenutnaY;

  void promeniAdresu(x,y)async{
    if(x!=null && y!=null){
      var lokacija=await Adresa.getAddressFromCoord(x, y);
      setState(() {
        lokacijaText=lokacija;
      });
    }
  }

  MapaDogadjaj mapa;
  void izaberiLokaciju() async {
    print("cekam lokaciju");
    print(trenutnaX.toString() + " " + trenutnaY.toString());
    if(mapa==null){
      mapa =(trenutnaX!=null && trenutnaY != null) ? MapaDogadjaj(trenutnaX, trenutnaY) : MapaDogadjaj(44.0175726, 20.907205);
      izabranoX=mapa.izabranaX;
      izabranoY=mapa.izabranaY;
    }
    else
      mapa=(mapa.izabranaX!=null && mapa.izabranaY != null) ? MapaDogadjaj(mapa.izabranaX, mapa.izabranaY) : MapaDogadjaj(44.0175726, 20.907205);

    Navigator.push(context, MaterialPageRoute(builder: (context) => mapa)).then((value){
      if(mapa.izabranaX!=null && mapa.izabranaY!=null){
        izabranoX=mapa.izabranaX;
        izabranoY=mapa.izabranaY;
        promeniAdresu(mapa.izabranaX, mapa.izabranaY);
      }
    });
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    //print(format.format(dt));//"6:00 AM"
    return format.format(dt);
  }

  _odaberiVreme() async{
    TimeOfDay vreme = await showTimePicker(context: context,
      initialTime: odabranoVreme,
    );
    if(vreme != null){
      setState(() {
        odabranoVreme = vreme;
      });
    }
  }
  _openGallery(BuildContext context) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 85,maxHeight: 1080,maxWidth: 1080);

    this.setState(() {
      _image = tempImage;
    });

    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 85,maxHeight: 1080,maxWidth: 1080);
    this.setState(() {
      _image = tempImage;
    });

    Navigator.of(context).pop();
  }

  Widget _imageView(){
    if(_image == null)
    {
      return GestureDetector(
        onTap: (){
          _showChoiceDialog(context);
        },
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.2)
          ),
          child: Center(
            child: Icon(Icons.add_a_photo),
          ),
        ),
      );
    }
    else
    {
      return Row(
        children: <Widget>[
          GestureDetector(
            child: Image.file(_image,width: 150,height: 150, fit: BoxFit.cover,),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => FullSizeImage(_image)),);
            },
          ),
          RaisedButton(
            color: Theme.of(context).accentColor,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPressed: (){
              _showChoiceDialog(context);
            },
            child: Text('Izmenite', style: TextStyle(color: Colors.white),),
          )
        ],
      );
    }
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('Odaberite'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.image),
                          Text(" Galerija")
                        ],
                      ),
                      onTap: () {
                        _openGallery(context);
                      }),
                  Padding(padding: EdgeInsets.all(8.0)),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.add_a_photo),
                        Text(" Kamera")
                      ],
                    ),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
            ],
          ),
        ),
      );
    });
  }


  void _submit() async {
    if( _naziv.text == '')
    {
      setState(() {
              _isEnabled=true;
            });
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Upozorenje"),
              content: Text("Vaš događaj mora imati naziv."),
            );
          });
    }
    else if(_image==null){
      setState(() {
              _isEnabled=true;
            });
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Upozorenje"),
              content: Text("Izaberite fotografiju."),
            );
          });
    }
    else if(izabranoX==null || izabranoY==null){
      setState(() {
              _isEnabled=true;
            });
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Upozorenje"),
              content: Text("Izaberite lokaciju."),
            );
          });
    }
    else
    {
      //povezivanje sa bekom
      String base64Image = base64Encode(_image.readAsBytesSync());
      String vremePom = formatTimeOfDay(odabranoVreme);
      String datumPom = odabraniDatum.toString();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
      var rezultat = await ApiDogadjaj.napravi(token,this.getNaziv,this.getOpis,datumPom,vremePom,base64Image,izabranoX,izabranoY);
      Navigator.pop(context);
      print(this.getOpis);
      print(this.getNaziv);
      print(vremePom);
      print(datumPom);
      if(rezultat == "ok"){
         showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Obaveštenje"),
          content: Container(child: Text("Uspešno ste dodali novi događaj"),),
        )
        ).then((value)  {
          _naziv.text="";
          _opis.text="";
          setState(() {
            _isEnabled=true;
          });
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PrikazDogadjaja()));
        });
        
      }
      else if(rezultat=="token"){
        showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Greška"),
          content: Container(child: Text("Došlo je do greške. Prijavite se ponovo."),),
        )
        );
        Odjava.OdjaviSe(context);
      }
      else if(rezultat==null){
        setState(() {
              _isEnabled=true;
            });
         showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Greška"),
          content: Container(child: Text("Došlo je do greške. Pokušajte kasnije."),),
        )
        );
      }
      else{
        showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Opomenuti ste"),
          content: Container(child: Text("Administrator aplikacije Moj Grad vas je opomenuo. Do "+rezultat+" ne možete da dodajete komentare, događaje, izazove i rešenja."),),
        )
        );
      }
    }
  }
}