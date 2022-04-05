import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moj_grad/post/PostPage.dart';
import 'package:moj_grad/resenje/ResenjaProblema.dart';

class PostSolution extends StatefulWidget {
  int postId;
  int idKorisnika;

  PostSolution(this.postId,this.idKorisnika);
  @override
  _PostSolutionState createState() => _PostSolutionState();
}

class _PostSolutionState extends State<PostSolution> with TickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Izazov'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).appBarTheme.textTheme.title.color,
          tabs: <Widget>[
            new Tab(child: Text("Izazov"),),
            new Tab(child: Text("Rešenja"),)
          ],
        ),
        ),
      body:TabBarView(
        controller: _tabController,
        children: <Widget>[
          PostPage(widget.postId, widget.idKorisnika),
          ResenjaProblema(widget.postId, widget.idKorisnika)
        ],
      )
    );
  }
}