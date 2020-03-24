import 'package:flutter/material.dart';
import 'package:vouched/src/routes.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () async {
                Navigator.of(context).pushNamed(Routes.DashboardPath);
              }),
        ),
        body: Center(
          child: Text('Settings'),
        ));
  }
}
