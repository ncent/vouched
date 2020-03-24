import 'dart:convert';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/blocs/post.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/post.dart';
import 'package:zefyr/zefyr.dart';

// ignore: must_be_immutable
class NewPost extends StatefulWidget {
  var _inputValue = "";

  @override
  NewPostState createState() {
    return new NewPostState();
  }
}

class NewPostState extends State<NewPost> {
  PostBloc _bloc;
  AuthBloc _authBloc;
  UserBloc _userBloc;

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<PostBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  NotusDocument _loadDocument() {
    return NotusDocument();
  }

  void onPost() async {
    _bloc.create(Post.withoutId(
        _authBloc.getUid,
        jsonEncode(_controller.document),
        '',
        (await _userBloc.getCurrentUser()).name,
        [],
        null,
        null,
        null,
        null,
        null,
        createdAt: Timestamp.now()));
    Navigator.of(context).pop<String>(widget._inputValue);
  }

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
                  child: Text('Post'),
                  onPressed: () {
                    onPost();
                  },
                  shape: StadiumBorder(),
                  elevation: 0.0,
                )
              ],
            ),
          )
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }
}
