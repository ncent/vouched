import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/user.dart';

class PageRouterSkill extends PageRouteBuilder {
  final UserBloc userBloc;
  final User user;
  final String skillUID;
  final String title;
  final String name;
  final double value;
  final String info;
  final String warning;
  final bool editing;

  PageRouterSkill({
    @required this.userBloc,
    @required this.user,
    @required this.skillUID,
    @required this.title,
    @required this.name,
    @required this.value,
    @required this.info,
    @required this.warning,
    @required this.editing,
  }) : super(pageBuilder: (
          BuildContext context,
          _,
          __,
        ) {
          return _EditSkill(
            skillUID: skillUID,
            userBloc: userBloc,
            user: user,
            title: title,
            name: name,
            value: value,
            info: info,
            warning: warning,
            editing: editing,
          );
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
}

class _EditSkill extends StatefulWidget {
  final String skillUID;
  final UserBloc userBloc;
  final User user;
  final String title;
  final String name;
  final double value;
  final String info;
  final String warning;
  final bool editing;

  _EditSkill({
    @required this.skillUID,
    @required this.userBloc,
    @required this.user,
    @required this.title,
    @required this.name,
    @required this.value,
    @required this.info,
    @required this.warning,
    @required this.editing,
  });

  @override
  _EditSkillState createState() => _EditSkillState();
}

class _EditSkillState extends State<_EditSkill> {
  final _textController = TextEditingController();
  double _value;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.value;
      _textController.text = widget.name;
    });
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
            onPressed: () {
              _save();
              Navigator.of(context).pop();
            },
          ),
          widget.editing
              ? IconButton(
                  onPressed: () async {
                    final result = await _checkRemove();
                    if (result) {
                      _remove();
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                  ),
                )
              : Container(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Skill Name'),
                  controller: _textController,
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
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Slider(
              min: 0.0,
              max: 1.0,
              value: _value,
              label: "${(_value * 100).toInt()}",
              divisions: 4,
              onChanged: (value) {
                setState(() => _value = value);
              },
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
    if (widget.editing) {
      final index = widget.user.skills
          .indexWhere((skill) => skill.uid == widget.skillUID);

      widget.user.skills.replaceRange(index, index + 1, [
        Skill(
          name: _textController.text,
          value: _value,
        )
      ]);
    } else {
      widget.user.skills.add(Skill(
        name: _textController.text,
        value: _value,
      ));
    }

    await widget.userBloc.updateSkills(widget.user.id, widget.user.skills);
  }

  _remove() async {
    setState(() => _isDirty = false);

    final index =
        widget.user.skills.indexWhere((skill) => skill.name == widget.name);
    widget.user.skills.removeAt(index);

    await widget.userBloc.updateSkills(widget.user.id, widget.user.skills);
  }

  _checkRemove() async {
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
            'Remove this skill?',
          ),
        );
      },
    );

    return Future.value(ret);
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
