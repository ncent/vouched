import 'package:flutter/material.dart';

class VTabBar extends StatelessWidget {
  final TabController tabController;

  VTabBar({@required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: tabController,
        labelPadding: EdgeInsets.symmetric(horizontal: 30.0),
        isScrollable: true,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.public)),
          Tab(icon: Icon(Icons.mail)),
          Tab(icon: Icon(Icons.star)),
        ]);
  }
}
