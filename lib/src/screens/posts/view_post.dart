import "package:flutter/material.dart";
import 'package:vouched/src/models/post.dart';

// ignore: must_be_immutable
class ViewPost extends StatefulWidget {
  final Post post;

  ViewPost({
    @required this.post,
  });

  @override
  ViewPostState createState() {
    return new ViewPostState();
  }
}

class ViewPostState extends State<ViewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Color(0xff3399ff),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: Row(
              children: <Widget>[
                RaisedButton(
                  child: Text('Share'),
                  onPressed: () {},
                  shape: StadiumBorder(),
                  elevation: 0.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: RaisedButton(
                    child: Text('Apply'),
                    onPressed: () {},
                    shape: StadiumBorder(),
                    elevation: 0.0,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      // body: Container(),
      body: widget.post?.message != null
          ? Text(widget.post.message)
          : Container(),
    );
  }
}
