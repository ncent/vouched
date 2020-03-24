import 'package:flutter/material.dart';
import 'package:vouched/src/constants/global.dart';
import 'package:vouched/src/models/user.dart';

class VMainAppbar extends StatelessWidget {
  final Future<User> user;
  final bool innerBoxIsScrolled;

  VMainAppbar({@required this.user}) : innerBoxIsScrolled = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user,
        builder: (BuildContext context, snapshot) {
          final User user = snapshot.data;
          final avatarString = user != null
              ? user.getName.toString().substring(0, 1).toUpperCase()
              : '';

          return SliverAppBar(
            leading: IconButton(
              icon: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                  child: Text(avatarString)),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            automaticallyImplyLeading: false,
            actions: <Widget>[Container()],
            primary: true,
            floating: true,
            snap: true,
            pinned: true,
            stretch: true,
            forceElevated: innerBoxIsScrolled,
          );
        });
  }
}
