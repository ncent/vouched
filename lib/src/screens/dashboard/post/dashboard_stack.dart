import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/screens/dashboard/post/post_content.dart';
import 'package:vouched/src/screens/dashboard/post/post_creator.dart';
import 'package:vouched/src/screens/dashboard/post/post_subject.dart';
import 'package:vouched/src/screens/dashboard/post/post_tags.dart';
import 'package:vouched/src/screens/widgets/vicons.dart';

const double BlurSigma = 3.2;
const double BottomAreaTopPadding = 10;
const double BottomAreaLeftPadding = 20;
const double BottomAreaRightPadding = 20;
const double BottomAreaBottomPadding = 30;
const double BottomPadding = 5;
typedef OnShowProfile();

class DashboardStack extends StatelessWidget {
  final Post post;
  final index;
  final Function showPostAction;
  final OnShowProfile onShowProfile;

  const DashboardStack({
    Key key,
    @required this.post,
    this.index,
    this.showPostAction,
    this.onShowProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    if (post.subject != null) {
      widgets.add(PostSubject(
        subject: post.subject,
      ));
    }

    if (post.tags.isNotEmpty) {
      widgets.add(
        PostTags(
          tags: post.tags,
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PostContent(
          content: post,
        ),
        _buildBottomArea(widgets, context),
      ],
    );
  }

  _buildBottomArea(List<Widget> widgets, context) {
    return Container(
      padding: EdgeInsets.only(bottom: 80.0, left: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => onShowProfile(),
            child: Padding(
              padding: EdgeInsets.only(left: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    VIcons.share,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'X referred this to you',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              PostCreator(
                avatar: post.avatar,
                onShowProfile: onShowProfile,
                creatorId: post.creator,
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets
                    .map(
                      (widget) => Padding(
                        padding: EdgeInsets.only(
                          bottom: BottomPadding,
                        ),
                        child: widget,
                      ),
                    )
                    .toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}
