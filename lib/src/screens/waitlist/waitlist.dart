import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/user.dart';

class WaitList extends StatefulWidget {
  @override
  WaitListState createState() => WaitListState();
}

class WaitListState extends State<WaitList> {
  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildScreen());
  }

  @override
  void deactivate() {
    _userBloc.dispose();
    super.deactivate();
  }

  Widget _buildScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "👏",
          style: TextStyle(
            fontSize: 70,
          ),
        ),
        Container(
          margin: EdgeInsets.all(30.0),
          child: Text(
            "Thank you for signing up, your profile is waiting for review.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }
}
