import 'package:flutter/material.dart';

class OverlayTour extends StatelessWidget {
  const OverlayTour({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.70),
        body: Stack(
          children: <Widget>[
            _contactsHint(context),
            _allButtonHint(context),
            _suggestedButtonHint(context),
            _closeButton(context),
          ],
        ));
  }

  _suggestedButtonHint(context) {
    return Positioned(
      left: 40,
      top: 150,
      child: Container(
        width: 300,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Text(
          'Slide right suggested to automatically send this post for all suggested contacts',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _contactsHint(context) {
    return Positioned(
      left: 40,
      top: 310,
      child: Container(
        width: 300,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Text(
          'Slide right to add the contact on suggested list, or slide left to remove from suggested list if alrady on suggested list',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _allButtonHint(context) {
    return Positioned(
      left: 40,
      top: 230,
      child: Container(
        width: 300,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Text(
          'Slide right all to automatically send this post for all contacts',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _closeButton(BuildContext context) {
    return Positioned(
      left: 84,
      top: MediaQuery.of(context).size.height - 100,
      child: FlatButton(
        color: Colors.transparent,
        child: Text(
          'Close This Tutorial',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
