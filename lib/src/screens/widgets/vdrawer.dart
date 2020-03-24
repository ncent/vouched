import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/routes.dart';

enum VDrawerID {
  WaitList,
  TrustedConnections,
  InviteContacts,
  Archive,
  Settings,
  Signout,
}

class VDrawer extends StatelessWidget {
  final _drawerMenuList = <Map<String, dynamic>>[
    {
      'id': VDrawerID.WaitList,
      'requiredRoles': [UserRole.Admin],
      'label': 'Wait List',
      'icon': Icon(Icons.format_list_bulleted),
      'onTapHandler': (context) async {
        await Navigator.pushNamed(context, Routes.WaitlistDashboardPath);
      },
    },
    {
      'id': VDrawerID.Signout,
      'requiredRoles': [UserRole.Admin, UserRole.User],
      'label': 'Signout',
      'icon': Icon(Icons.exit_to_app),
      'onTapHandler': (context) async {
        final authBloc = BlocProvider.of<AuthBloc>(context);
        await authBloc.signOut();
        await authBloc.changeAuthStatus(null);
        await Navigator.pushNamed(context, Routes.AuthRoutePath);
      },
    }
  ];

  final Future<User> user;
  final Function(VDrawerID) menuCallback;

  VDrawer({
    @required this.user,
    this.menuCallback,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          final menus = List<Widget>();
          final User user = snapshot.data;
          menus.add(_buildUserMenu(context, user));
          menus.addAll(_buildItemMenus(context, user));

          return Drawer(
            child: Column(
              children: menus,
            ),
          );
        });
  }

  _buildUserMenu(context, User user) {
    final minHeight = 228.0;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.ProfilePath,
          arguments: user.id,
        );
      },
      child: Container(
        color: Colors.grey[100],
        width: double.infinity,
        height: minHeight,
        margin: EdgeInsets.all(0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: 16,
                      top: 15,
                    ),
                    child: user.avatar != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                            radius: 40,
                          )
                        : CircleAvatar(
                            radius: 40,
                            child: Icon(
                              Icons.person,
                              size: 60,
                            ),
                          ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 16,
                  top: 14,
                ),
                child: Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 16,
                ),
                child: Text(
                  user.email ?? user.phone ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildItemMenus(context, User user) {
    return _drawerMenuList
        .where((menu) =>
            (menu['requiredRoles'] as List<UserRole>).contains(user.role))
        .map((menu) {
      return ListTile(
        onTap: () async {
          await menu['onTapHandler'](context);
          if (menuCallback != null) {
            menuCallback(menu['id']);
          }
        },
        title: Text(menu['label']),
        trailing: menu['icon'],
      );
    }).toList();
  }
}
