import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/pretraga/ApiSearch.dart';

class SearchPage extends StatefulWidget{
  
_SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController _searchController = TextEditingController();

  List<Widget> listContent=List<Widget>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:CupertinoTextField(
          controller: _searchController,
          style: TextStyle(color:Theme.of(context).appBarTheme.textTheme.title.color),
          clearButtonMode: OverlayVisibilityMode.editing,
          onChanged: (String text) async {
            if(text.length >= 3){
              var temp=await ApiSearch.getContent(text);
              setState(() {
                listContent=temp;
              });
            }
            else if(text==""){
              setState(() {
                listContent=[];
              });
            }
          },
        ),
      ),
      body: (listContent.length==0) ? Center(
        child: Image.asset('Slike/blankpage.png',width: (MediaQuery.of(context).size.width * 9) / 10,)
      ) : 
      ListView.builder(
        itemCount: listContent.length,
        itemBuilder: (BuildContext context,int index){
          return listContent[index];
        }
      )
    );
  }

}