import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' ;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dogadjaji/DodajDogadjaj.dart';
class PrikazKalendara extends StatefulWidget{
  @override
  _PrikazKalendaraState createState() => _PrikazKalendaraState();
}
class _PrikazKalendaraState extends State<PrikazKalendara>{
  DateTime datum = new DateTime.now();
  DateTime _currentDate = new DateTime.now();
  static String noEventText = "Nema događaja";
  String calendarText = noEventText;
  Color _colorButtonColor = Colors.indigo;
  Color _colorTextButtonColor = Colors.black;
  Color _colorTextTodayButton = Colors.white;



  @override
  void initState() {
    super.initState();
    getCalendarEventList();
  }


  @override
  void dispose() {
    _markedDateMap.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Kalendar događaja"),),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: CalendarCarousel(
                    weekendTextStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                    weekFormat: false,
                    selectedDateTime: _currentDate,
                    markedDatesMap: _markedDateMap,
                    selectedDayBorderColor: Colors.transparent,
                    selectedDayButtonColor: Theme.of(context).accentColor,
                    todayTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDayTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    todayBorderColor: Theme.of(context).accentColor,
                    weekdayTextStyle: TextStyle(
                      color: Colors.black,
                    ),
                    height: 420.0,
                    locale: 'eng',
                    daysHaveCircularBorder: true,
                    todayButtonColor: Colors.transparent,
                    onDayPressed: (DateTime date, List<Event> events){
                      setState(() {
                        datum = date;

                      });
                      this.setState(() => refresh(date));
                    },

                  )

              ),

              Container(
                height: 100,
                child:
                CustomScrollView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(20.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Text(calendarText),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NapraviDogadjaj(datum)),
          );
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }

  void refresh(DateTime date){
    calendarText = '';
    var broj = 1;
    _currentDate = date;
    var i = 0;
    if(_markedDateMap.getEvents(new DateTime(date.year,date.month,date.day)).isNotEmpty){
      var duzina =  _markedDateMap.getEvents(new DateTime(date.year,date.month,date.day)).length;
      for( i; i < duzina; i++) {
        //print(duzina);
        calendarText +=  _markedDateMap.getEvents(
            new DateTime(date.year, date.month, date.day))[i].title +  "\n\n";
        broj++;
      }
    }else{
      calendarText = noEventText;
    }
    if(date == _currentDate){
      _colorButtonColor = Colors.indigo;
      _colorTextButtonColor = Colors.white;
      _colorTextTodayButton = Colors.white;
    } else {
      _colorTextButtonColor = Colors.indigo;
      _colorTextTodayButton = Colors.black;
    }
  }



  EventList<Event> _markedDateMap = new EventList<Event>(events: {
    new DateTime(2020,1,1): [
      new Event(date: new DateTime(2020,2,25),
          title: "Opis nekog dogadjaja",
      )
    ],
  });

  Future<void> getCalendarEventList() async{
    double x;
    double y;
    x = 1;
    y = 1;
    Map<String,dynamic> map = new Map<String,dynamic>();
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    map["token"]=prefs.getString("token");

    var jsonBody = json.encode(map);

    Map<String, String> header={
    "Content-type" : "application/json",
    "Accept" : "application/json"
  };
    var response = await http.post("http://147.91.204.116:2048/dogadjaj/mojaPrisustva",headers: header,body: jsonBody);

    if(response.statusCode == 200){
      var jsonData = json.decode(response.body);
      for (var e in jsonData){
        //var datum = new DateFormat('dd.MM.yyyy').format(DateTime.parse(e['datum']));
        var datum = DateTime.parse(e['datum']);
        var vreme = new DateFormat('HH:mm').format(DateTime.parse(e['datum']));
       // print(vreme);

        _markedDateMap.add(new DateTime(datum.year,datum.month,datum.day), new Event(date: new DateTime(datum.year,datum.month,datum.day),
            title: e['naslov'] + " \n" +"   " + "Vreme održavanja:" +  vreme));

        setState(() {

        });
      }
    }
  }
}