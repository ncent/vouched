import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/models/user.dart';

class VBottomAppBar extends StatelessWidget {
  final FocusNode focusNode;
  final Future<User> user;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function showRequiredSignInWarning;

  VBottomAppBar(
      {@required this.focusNode,
      @required this.scaffoldKey,
      @required this.user,
      @required this.showRequiredSignInWarning});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user,
      builder: (context, snapshot) {
        final User user = snapshot.data;
        final userInitial =
            user?.getName.toString().substring(0, 2).toUpperCase();

        return BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 35.0,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? Colors.blue
                            : Colors.white,
                    child: Text(
                      userInitial ?? "",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  onPressed: () async {
                    if (user.isAnonymous) {
                      await showRequiredSignInWarning();
                    } else {
                      scaffoldKey.currentState.openDrawer();
                    }
                  },
                ),
                IconButton(
                  focusNode: focusNode,
                  autofocus: true,
                  icon: Icon(Icons.chat),
                  onPressed: () {},
                ),
              ],
            ));
      },
    );
  }
}
