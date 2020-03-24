import 'dart:typed_data';

import 'package:flutter/material.dart';

const AvatarStarColor = 0xff57aff5;

class ContactAvatar extends StatelessWidget {
  final bool isSuggestedAvatar;
  final Uint8List avatar;
  final String initials;

  const ContactAvatar({
    Key key,
    this.avatar,
    this.initials,
    this.isSuggestedAvatar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarWidget = (avatar != null && avatar.length > 0)
        ? CircleAvatar(
            backgroundImage: MemoryImage(avatar),
          )
        : CircleAvatar(
            child: Text((initials.toUpperCase()),
                style: TextStyle(color: Colors.white)),
          );

    return isSuggestedAvatar
        ? _buildSpecialIndicator(avatarWidget)
        : avatarWidget;
  }

  _buildSpecialIndicator(CircleAvatar circleAvatar) {
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
                  Colors.blue,
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
            Icons.star,
            color: Color(AvatarStarColor),
          ),
        )
      ],
    );
  }
}
