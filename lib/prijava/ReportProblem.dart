import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/adresa/Adresa.dart';
import 'package:moj_grad/mapa/mapaApi.dart';
import 'package:moj_grad/odjava/Odjava.dart';
import 'package:moj_grad/prijava/Mapa.dart';
import 'ApiPrijava.dart';
import 'package:moj_grad/kategorija/Kategorija.dart';
import 'package:image_picker/image_picker.dart';

import 'FullSizeImage.dart';

class ReportProblem extends StatefulWidget {
  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  static final TextEditingController _naslov = new TextEditingController();
  String get getNaslov => _naslov.text;

  static final TextEditingController _opis = new TextEditingController();
  String get getOpis => _opis.text;

  bool _isEnabled;
  String lokacijaText="Uključite lokaciju na vašem uređaju.";
  double izabranoX;
  double izabranoY;

  List<File> listImages = List<File>();

  void _submit() async {
    if (_naslov.text == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Upozorenje"),
              content:
                  Text("Neophodno je uneti naslov."),
            );
          });
    }
    else if(izabranoX==null || izabranoY==null){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Upozorenje"),
              content:
                  Text("Neophodno je izabrati lokaciju."),
            );
          });
    }
    else if(listImages.length==0 || listImages[0]==null)
    {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Upozorenje"),
              content:
                  Text("Neophodno je izabrati fotografiju."),
            );
          });
    }
     else {
      //String base64Image = base64Encode(_image.readAsBytesSync());
      int idKategorije = _selektovanaKategorija.id;

      setState(() {
        _isEnabled = false;
      });
      double x = izabranoX;
      double y = izabranoY;
      print("izabrano " + x.toString() + " " + y.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
      var rez = await ApiPrijava.prijaviProblem(
          idKategorije, listImages, this.getNaslov, this.getOpis, x, y);
      Navigator.of(context).pop(true);
      if (rez == "ok") {
        print("Uspesno dodavanje slike");
        _opis.text = "";
        _naslov.text = "";
        Navigator.of(context).pop(true);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Obaveštenje"),
                content: Text("Uspešno ste objavili izazov."),
              );
            });
      } else if(rez==null){
        setState(() {
          _isEnabled = true;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Greska"),
                content: Text("Pokušajte ponovo."),
              );
            });
      }
      else if(rez=="token"){
        showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Greška"),
          content: Container(child: Text("Došlo je do greške. Prijavite se ponovo."),),
        )
        );
        Odjava.OdjaviSe(context);
      }
      else{
        setState(() {
          _isEnabled = true;
        });
        showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text("Opomenuti ste"),
          content: Container(child: Text("Administrator aplikacije Moj Grad vas je opomenuo. Do "+rez+" ne možete da dodajete komentare, događaje, izazove i rešenja."),),
        )
        );
      }
    }
  }

  //  Dropdown meni za kategorije
  List<Kategorija> _kategorije;
  List<DropdownMenuItem<Kategorija>> _dropdownMenuItems;
  Kategorija _selektovanaKategorija;

  List<DropdownMenuItem<Kategorija>> buildDropdownMenuItems(List kategorije) {
    List<DropdownMenuItem<Kategorija>> items = List();
    for (Kategorija k in kategorije) {
      items.add(DropdownMenuItem(
        value: k,
        child: Text(k.naziv),
      ));
    }
    return items;
  }

  onChangeDropdownItem(Kategorija selektovana) {
    setState(() {
      _selektovanaKategorija = selektovana;
    });
  }

  Future<Widget> ucitajPolja() async {
    if (_kategorije == null) {
      _kategorije = await Kategorija.getKategorije();
      _dropdownMenuItems = buildDropdownMenuItems(_kategorije);
      _selektovanaKategorija = _dropdownMenuItems[0].value;
    }

    return DropdownButton(
      value: _selektovanaKategorija,
      items: _dropdownMenuItems,
      onChanged: onChangeDropdownItem,
    );
  }

  double trenutnaX;
  double trenutnaY;
  @override
  void initState() {
    super.initState();
    MapaAPI.dajPoziciju().then((p)async {
      trenutnaX = p.latitude;
      trenutnaY = p.longitude;

      if(trenutnaX!=null && trenutnaY!=null){
        izabranoX=trenutnaX;
        izabranoY=trenutnaY;
        var lokacija=await Adresa.getAddressFromCoord(trenutnaX, trenutnaY);
        setState(() {
          lokacijaText=lokacija;
        });
      }
    });
    listImages = [null,null,null,null];
  }
  void promeniAdresu(x,y)async{
    if(x!=null && y!=null){
      var lokacija=await Adresa.getAddressFromCoord(x, y);
      setState(() {
        lokacijaText=lokacija;
      });
    }
  }

  Mapa mapa;
  void izaberiLokaciju() async {
    print("cekam lokaciju");
    print(trenutnaX.toString() + " " + trenutnaY.toString());
    if(mapa==null){
      mapa =(trenutnaX!=null && trenutnaY != null) ? Mapa(trenutnaX, trenutnaY) : Mapa(44.0175726, 20.907205);
      izabranoX=mapa.izabranaX;
      izabranoY=mapa.izabranaY;
    }
    else
      mapa=(mapa.izabranaX!=null && mapa.izabranaY != null) ? Mapa(mapa.izabranaX, mapa.izabranaY) : Mapa(44.0175726, 20.907205);

    Navigator.push(context, MaterialPageRoute(builder: (context) => mapa)).then((value){
      if(mapa.izabranaX!=null && mapa.izabranaY!=null){
        izabranoX=mapa.izabranaX;
        izabranoY=mapa.izabranaY;
        promeniAdresu(mapa.izabranaX, mapa.izabranaY);
      }
    });
  }

  _openGallery(BuildContext context,index) async {
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 1080,maxHeight: 1080);

    this.setState(() {
      listImages[index]=tempImage;
    });

    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context,index) async {
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 1080,maxHeight: 1080);
    this.setState(() {
      listImages[index]=tempImage;
    });

    Navigator.of(context).pop();
  }


  Future<void> _showChoiceDialog(BuildContext context,index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                        _openGallery(context,index);
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
                      _openCamera(context,index);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget odabirCont(index){
    if(listImages.length==0 || listImages[index]==null)
      return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color:Theme.of(context).accentColor,
          borderRadius:BorderRadius.all(Radius.circular(16.0)),
        ),
        child: IconButton(
          icon: Icon(Icons.add_a_photo, color: Colors.white,),
          onPressed: () {
            _showChoiceDialog(context, index);
          },
        ),
      );
    else
      return Container(
        child: Stack(
              children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullSizeImage(listImages[index])),);
                },
                child: Image.file(
                    listImages[index],
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover
                  ),
              ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        listImages[index]=null;
                        listImages.sort((a, b) => a == null ? 1 : 0);
                      });
                    },
                  ),
                ),
              ],
            ),
      );
  }

  Widget gridCont(){
    return Container(
      //height: 320,
      child: GridView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
        ),
        children: <Widget>[
          odabirCont(0),
          (listImages[0]!=null) ? odabirCont(1) : Container(),
          (listImages[0]!=null && listImages[1]!=null) ? odabirCont(2) : Container(),
          (listImages[0]!=null && listImages[1]!=null && listImages[2]!=null) ? odabirCont(3) : Container(),
      ],)
    );
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Objavljivanje izazova'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                FutureBuilder(
                    future: ucitajPolja(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null)
                        return Text("Učitavanje...");
                      else
                        return snapshot.data;
                    }),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      maxLength: 80,
                      controller: _naslov,
                      decoration: InputDecoration(
                          hintText: "Naslov",
                          fillColor: Theme.of(context).accentColor,
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              borderSide: BorderSide(color: Theme.of(context).accentColor)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)))),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      maxLines: 3,
                      maxLength: 255,
                      controller: _opis,
                      decoration: InputDecoration(
                          hintText: "Opis",
                          fillColor: Theme.of(context).accentColor,
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              borderSide: BorderSide(color: Theme.of(context).accentColor)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)))),
                ),
                Padding(
                  padding:  EdgeInsets.all(10.0),
                  child: lokacijaText!=null ? Text(lokacijaText) : Text("Uključite lokaciju na vašem uređaju."),
                ),
                SizedBox(
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: izaberiLokaciju,
                    child: Text("Izaberite drugu lokaciju", style: TextStyle(color:Colors.white),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: gridCont(),
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  onPressed: (_isEnabled == null || _isEnabled == true)
                      ? _submit
                      : null,
                  child: Text("Objavite izazov", style: TextStyle(color:Colors.white),),
                ),
              ],
            ),
          ),
        ));
  }
}
