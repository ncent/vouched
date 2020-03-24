import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const MaxTagsLength = 3;

class PostTags extends StatelessWidget {
  final List<String> tags;

  const PostTags({
    Key key,
    @required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxLen = tags.length >= MaxTagsLength ? MaxTagsLength : tags.length;
    final tagsRow = <Widget>[];

    for (var i = 0; i < maxLen; i++) {
      tagsRow.add(Container(
        margin: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 2,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 2,
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent,
              width: 0.4,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                4,
              ),
            )),
        child: Text(
          tags[i],
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ));
    }

    return Row(
      children: tagsRow,
    );
  }
}
