import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moj_grad/Loader/Loader.dart';
import 'package:moj_grad/profil/PrikazProfila.dart';
import 'package:moj_grad/resenje/ApiResenje.dart';
import 'package:numberpicker/numberpicker.dart';

class ResenjeContainer extends StatefulWidget {
  int autorPosta;
  int idPosta;
  int idKorisnika;
  int idResenja;
  DateTime datum;
  String userImg;
  int autorResenja;
  String username;
  String opis;
  int ocena;
  String formDatum;
  List<String> slike;
  List<NetworkImage> images = [];
  
  ResenjeContainer(this.autorPosta,this.idPosta,this.idKorisnika,this.datum,this.userImg,this.autorResenja,this.ocena,this.opis,this.slike,this.username,this.idResenja){
    DateFormat f = DateFormat("dd.MM.yyyy.");
    formDatum=f.format(datum);
    for(var s in slike){
        images.add(NetworkImage(s));
    }
  }
  @override
  _ResenjeContainerState createState() => _ResenjeContainerState(ocena);
}

class _ResenjeContainerState extends State<ResenjeContainer> {
bool enabled=true;
int ocena;
_ResenjeContainerState(this.ocena);

  List getImages(){
    List imgs = [];
    for(var s in widget.slike){
      imgs.add(NetworkImage(s));
    }
    return imgs;
  }
  int izbor = 4;

  /*void _showDialog()  {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        /*return new NumberPickerDialog(
          minValue: 1,
          maxValue: 10,
          title: new Text("Pick a new price"),
          initialDoubleValue: _currentPrice,
        );*/
        return new NumberPicker.integer(
          initialValue: izbor,
          minValue: 1,
          maxValue: 5,
          onChanged: (value){
            setState(() {
              izbor=value;
            });
          },
          );
      }
    );
  }*/
  Future _showIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 1,
          maxValue: 5,
          step: 1,
          initialIntegerValue: 5,
          infiniteLoop: true,
        );
      },
    ).then((num value) async{
      if (value != null) {
        setState(() {
          enabled=false;
        });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));
      var res = await ApiResenje.oceni(widget.idResenja, value.ceil());
      Navigator.pop(context);
      //print(res.toString());
      if(res==true){
        setState(() {
          ocena=value.ceil();
        });
        print("sve ok");
      }
      else{
        setState(() {
          enabled=true;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Greska!"),
              content:
                  Text("Pokusajte ponovo"),
            );
          });
      }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top:10,bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(17),
        boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 8.0,
              offset: const Offset(4, 4)
            )
          ]
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: GestureDetector(
                    child: CircleAvatar(backgroundImage: NetworkImage(widget.userImg),),
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazProfila(widget.autorResenja)),);},
                  ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(widget.username,style: TextStyle(fontSize: 20),),
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PrikazProfila(widget.autorResenja)),);},
                    ),
                    Text(widget.formDatum)
                  ],
                )
              ],
            ),
          ),
          Container(
             width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            constraints: BoxConstraints(maxHeight: 400),
            child: Carousel(
              dotSize: 4.0,
              dotBgColor: Colors.transparent,
              dotSpacing: 10,
              dotColor: Theme.of(context).accentColor,
              //showIndicator: false,
              images: getImages(),
              autoplay: false,
              boxFit: BoxFit.fitHeight,
            ),
          ),
          widget.opis==null?Container():Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(widget.opis),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: ocena==0?Container():
                  Column(
                    children: <Widget>[
                      Icon(Icons.star,size: 35,color: Theme.of(context).accentColor,),
                      Text(ocena.toString())
                    ],
                  ),
                ),
                ocena==0&&widget.idKorisnika==widget.autorPosta?
                Expanded(
                  
                  child: FlatButton(child:Text("Oceni",style: TextStyle(fontSize: 20),),onPressed: enabled==true?_showIntDialog:null ),
                ):Container()
              ],
            )
          )

          
        ],
      ),
    );
  }
}
