import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyDashboardStack extends StatelessWidget {
  const EmptyDashboardStack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: Text('No Posts Found'),
        )
      ],
    );
  }
}
