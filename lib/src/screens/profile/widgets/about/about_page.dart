import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/screens/profile/widgets/about/about_edit.dart';

class AboutPage extends StatelessWidget {
  final UserBloc userBloc;
  final User user;
  final bool allowUserEdit;

  const AboutPage({
    @required this.userBloc,
    @required this.user,
    @required this.allowUserEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              bottom: 20,
            ),
            child: Text('About',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
          _buildProfileDesc(context, userBloc, user),
          Divider(),
          _buildProfileBio(context),
        ],
      ),
    );
  }

  _buildProfileDesc(context, userBloc, user) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 200,
            child: GestureDetector(
              onTap: () {
                if (allowUserEdit) {
                  _editHeadline(context, userBloc, user);
                }
              },
              child: Text(
                user.headline ?? 'Not defined yet',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          allowUserEdit
              ? Container(
                  child: Text(
                    "Tap to update",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  _buildProfileBio(context) {
    return GestureDetector(
      onTap: () {
        if (allowUserEdit) {
          _editBio(context, userBloc, user);
        }
      },
      child: Text(
        user.bio ?? 'Not defined yet',
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  _editHeadline(context, userBloc, user) {
    return Navigator.of(context).push(
      PageRouterEdit(
        placeholder: 'Add your headline',
        userBloc: userBloc,
        lines: 2,
        fieldToEdit: 'headline',
        title: "Edit Headline",
        user: user,
        info:
            "You can add headline. Anyone who see your profile will the headline",
        warning: "Are you sure you want to exit without save?",
      ),
    );
  }

  _editBio(context, userBloc, user) {
    return Navigator.of(context).push(
      PageRouterEdit(
        placeholder: 'Add your bio',
        userBloc: userBloc,
        lines: 8,
        fieldToEdit: 'bio',
        title: "Edit Bio",
        user: user,
        info: "You can add bio. Anyone who see your profile will the bio",
        warning: "Are you sure you want to exit without save?",
      ),
    );
  }
}
