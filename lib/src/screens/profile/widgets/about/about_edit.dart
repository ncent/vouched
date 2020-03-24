import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/user.dart';

class PageRouterEdit extends PageRouteBuilder {
  final UserBloc userBloc;
  final User user;
  final String fieldToEdit;
  final String placeholder;
  final String title;
  final String info;
  final String warning;
  final int lines;

  PageRouterEdit({
    @required this.userBloc,
    @required this.user,
    @required this.fieldToEdit,
    @required this.placeholder,
    @required this.title,
    @required this.info,
    @required this.warning,
    this.lines = 1,
  }) : super(
          pageBuilder: (
            BuildContext context,
            _,
            __,
          ) {
            return _EditField(
              userBloc: userBloc,
              title: title,
              user: user,
              fieldToEdit: fieldToEdit,
              placeholder: placeholder,
              info: info,
              warning: warning,
              lines: lines,
            );
          },
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            final begin = Offset(1.0, 0.0);
            final end = Offset.zero;
            final curve = Curves.ease;

            final tween = Tween(begin: begin, end: end).chain(
              CurveTween(
                curve: curve,
              ),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

class _EditField extends StatefulWidget {
  final UserBloc userBloc;
  final String title;
  final User user;
  final String fieldToEdit;
  final String placeholder;
  final String info;
  final String warning;
  final int lines;

  _EditField({
    @required this.userBloc,
    @required this.title,
    @required this.user,
    @required this.fieldToEdit,
    @required this.placeholder,
    @required this.info,
    @required this.warning,
    this.lines,
  });

  @override
  _EditFieldState createState() => _EditFieldState();
}

class _EditFieldState extends State<_EditField> {
  final _textController = TextEditingController();
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();

    setState(
        () => _textController.text = widget.user.toJson()[widget.fieldToEdit]);

    _textController.addListener(
      () => setState(
        () => _isDirty =
            widget.user.toJson()[widget.fieldToEdit] != _textController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () async {
            final canClose = await _checkNeedsSave();
            if (canClose) {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () async {
              await _save();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextField(
              maxLines: widget.lines,
              controller: _textController,
              decoration: InputDecoration(
                hintText: widget.placeholder,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              widget.info,
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    setState(() => _isDirty = false);
    final userUpdate = widget.user.toJson();
    userUpdate[widget.fieldToEdit] = _textController.text;
    await widget.userBloc.update(User.fromJson(userUpdate));
  }

  _checkNeedsSave() async {
    if (!_isDirty) {
      return Future.value(true);
    }

    bool ret = false;

    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                ret = true;
                Navigator.of(ctx).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
          content: Text(
            widget.warning,
          ),
        );
      },
    );

    return Future.value(ret);
  }
}
