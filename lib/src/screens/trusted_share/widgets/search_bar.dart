import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const double RightLeftPadding = 2;
const double TopBottomPadding = 0;
const String SearchContactText = 'Search contact';

typedef OnTextSearch(String text);

class SearchBar extends StatelessWidget {
  final OnTextSearch onTextSearch;

  const SearchBar({
    Key key,
    this.onTextSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: RightLeftPadding,
        right: RightLeftPadding,
        bottom: TopBottomPadding,
        top: TopBottomPadding,
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          hintText: SearchContactText,
        ),
        onChanged: (text) {
          onTextSearch?.call(text);
        },
      ),
    );
  }
}
