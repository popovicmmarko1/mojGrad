import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/prijava/FullSizeImage.dart';
import 'package:moj_grad/resenje/ApiResenje.dart';
import 'dart:io';
import '../odjava/Odjava.dart';

class DodajResenje extends StatefulWidget {
  int idPosta;

  DodajResenje(this.idPosta);
  
  @override
  _DodajResenjeState createState() => _DodajResenjeState();
}

class _DodajResenjeState extends State<DodajResenje> {
  TextEditingController _opis = new TextEditingController();
  String get getOpis => _opis.text;

  bool _isEnabled;
  List<File> listImages = List<File>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listImages = [null,null,null,null];
  }

  void _submit() async {
    if (listImages.length==0 || listImages[0]==null ) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Upozorenje"),
              content:
                  Text("Morate izabrati sliku"),
            );
          });
    } else {
      //String base64Image = base64Encode(_image.readAsBytesSync());
      

      setState(() {
        _isEnabled = false;
      });
     
     
      //var rez = await ApiPrijava.prijaviProblem(idKategorije, images, this.getNaslov, this.getOpis, x, y);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
      var rez =await ApiResenje.dodajResenje(listImages, this.getOpis, widget.idPosta);
      Navigator.of(context).pop(true);
      if (rez == "ok") {
        _opis.text = "";
        Navigator.of(context).pop(true);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Obaveštenje"),
                content: Text("Uspešno ste dodali rešenje"),
              );
            });
      } 
      else if(rez==null)
      {
        setState(() {
          _isEnabled = true;
        });
        Navigator.of(context).pop(true);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Greška!"),
                content: Text("Već ste dodali rešenje"),
              );
            });
      }
      else if(rez=="token"){
        Odjava.OdjaviSe(context);
      }
      else{
         setState(() {
          _isEnabled = true;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Opomenuti ste"),
                content: Container(child: Text("Administrator aplikacije Moj Grad vas je opomenuo. Do "+rez+" ne možete da dodajete komentare, događaje, izazove i rešenja."),),
              );
            });
      }
    }
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
      appBar: AppBar(title: Text("Dodavanje rešenja"),),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
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
                  child: Text("Dodaj rešenje",style: TextStyle(color:Colors.white),),
                ),
            ],
          ),
        ),
      ),
    );
  }
}