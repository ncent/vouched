import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const style = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(
      color: Colors.blueGrey,
      offset: Offset(2, 2),
    ),
  ],
);

class PostSubject extends StatelessWidget {
  final String subject;
  final String avatar;

  const PostSubject({Key key, @required this.subject, this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(subject, style: style),
        SizedBox(
          width: 5.0,
        ),
        Text(
          "·",
          style: style,
        ),
        SizedBox(
          width: 5.0,
        ),
        GestureDetector(
            child: Text("apply",
                style: TextStyle(
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      color: Colors.blueGrey,
                      offset: Offset(2, 2),
                    ),
                  ],
                )),
            onTap: () {
              print("apply");
            })
      ],
    );
  }
}
