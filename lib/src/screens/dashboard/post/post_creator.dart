import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnShowProfile();

class PostCreator extends StatelessWidget {
  final String creatorId;
  final String avatar;
  final OnShowProfile onShowProfile;

  const PostCreator({
    Key key,
    @required this.avatar,
    @required this.creatorId,
    this.onShowProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onShowProfile(),
        child: _buildSpecialIndicator(
            CircleAvatar(
              child: Icon(
                Icons.person,
              ),
            ),
            Icons.star));
  }

  _buildSpecialIndicator(CircleAvatar circleAvatar, IconData icon) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white,
                  Colors.amberAccent,
                ],
              )),
          alignment: AlignmentDirectional.center,
          width: 45,
          height: 45,
        ),
        Padding(
          padding: const EdgeInsets.all(2.4),
          child: circleAvatar,
        ),
        Padding(
          padding: EdgeInsets.only(top: 25, left: 25),
          child: Icon(
            icon,
            color: Colors.amberAccent,
          ),
        )
      ],
    );
  }
}
