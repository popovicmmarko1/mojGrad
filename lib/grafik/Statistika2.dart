import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Statistika2 extends StatelessWidget {
  

  Future<List<charts.Series<Series,String>>> getData()async{
    
    List<Series> lista =[];
    var res = await http.get("http://147.91.204.116:2048/stat/solvedUnsolved");
    if(res.statusCode!=200) return [];
    var data = json.decode(res.body);
    //print(data);
    var reseni = Series("Rešeni", data['reseni'],charts.ColorUtil.fromDartColor(Colors.green));
    lista.add(reseni);
    
    var nereseni = Series("Nerešeni", data['nereseni'],charts.ColorUtil.fromDartColor(Colors.red));
    lista.add(nereseni);

   
    
    List<charts.Series<Series,String>> series = [
      charts.Series(
        id: "Identifikator",
        data: lista,
        domainFn: (Series s,_)=>s.naziv,
        measureFn: (Series s,_)=>s.broj,
        colorFn: (Series s,_)=>s.boja,
        labelAccessorFn: (Series row, _) => '${row.naziv}: ${row.broj}',
        )
    ];
    return series;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<List<charts.Series<Series,String>>> snapshot){
          
         return snapshot.hasData? Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.report_problem,color: Colors.red,),
                    Expanded(child:Text("  Nerešeni izazovi"),),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("4"),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 27, 30, 0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.check_box,color: Colors.green,),
                    Expanded(child:Text("  Rešeni izazovi"),),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("5"),
                    )
                  ],
                ),
              ),
              Container(
                
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height/3*2,
                child: charts.PieChart(
                snapshot.data,animate: true,
                defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 100,
                arcRendererDecorators: [new charts.ArcLabelDecorator()])
              ),
              ),
              Container(child:Text("Odnos rešenih i nerešenih izazova",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),padding: EdgeInsets.fromLTRB(0, 0, 0, 50),)
              
            ],
          )
    ):Container(child: Center(child: CircularProgressIndicator(),),);
      });
  }


}
class Series{
  final String naziv;
  final int broj;
  final charts.Color boja;

  Series(this.naziv,this.broj,this.boja);
}