import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/user.dart';

class PageRouterJobHistory extends PageRouteBuilder {
  final UserBloc userBloc;
  final User user;
  final String jobHistoryUID;
  final String title;
  final String jobTitle;
  final String jobWhereTitle;
  final DateTime jobStart;
  final DateTime jobEnd;
  final String info;
  final String warning;
  final bool editing;

  PageRouterJobHistory({
    @required this.jobHistoryUID,
    @required this.userBloc,
    @required this.user,
    @required this.title,
    @required this.jobTitle,
    @required this.jobWhereTitle,
    @required this.jobStart,
    @required this.jobEnd,
    @required this.info,
    @required this.warning,
    @required this.editing,
  }) : super(pageBuilder: (
          BuildContext context,
          _,
          __,
        ) {
          return _EditJobHistory(
            jobHistoryUID: jobHistoryUID,
            userBloc: userBloc,
            user: user,
            title: title,
            jobTitle: jobTitle,
            jobWhereTitle: jobWhereTitle,
            jobStart: jobStart,
            jobEnd: jobEnd,
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

class _EditJobHistory extends StatefulWidget {
  final String jobHistoryUID;
  final UserBloc userBloc;
  final User user;
  final String title;
  final String jobTitle;
  final String jobWhereTitle;
  final DateTime jobStart;
  final DateTime jobEnd;
  final String info;
  final String warning;
  final bool editing;

  _EditJobHistory({
    @required this.jobHistoryUID,
    @required this.userBloc,
    @required this.user,
    @required this.title,
    @required this.jobTitle,
    @required this.jobWhereTitle,
    @required this.jobStart,
    @required this.jobEnd,
    @required this.info,
    @required this.warning,
    @required this.editing,
  });

  @override
  _EditJobHistoryState createState() => _EditJobHistoryState();
}

class _EditJobHistoryState extends State<_EditJobHistory> {
  final _jobTitleTextController = TextEditingController();
  final _jobWhereTitleTextController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  DateTime _tmpStartDate = DateTime.now();
  DateTime _tmpEndDate = DateTime.now();
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _jobTitleTextController.text = widget.jobTitle;
      _jobWhereTitleTextController.text = widget.jobWhereTitle;
      _startDate = widget.jobStart;
      _endDate = widget.jobEnd;
      _tmpStartDate = widget.jobStart;
      _tmpEndDate = widget.jobEnd;
    });

    _jobTitleTextController.addListener(
      () => setState(
        () => _isDirty = (widget.jobTitle != _jobTitleTextController.text ||
            widget.jobWhereTitle != _jobWhereTitleTextController.text),
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
      body: Builder(
        builder: (context) {
          return _buildJobInfo(context);
        },
      ),
    );
  }

  Future<Null> _setStartDate(context) async {
    return showDialog(
      context: context,
      child: AlertDialog(
        content: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _startDate,
            onDateTimeChanged: (DateTime value) {
              setState(() {
                _tmpStartDate = value;
              });
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Confirm'),
            onPressed: () {
              setState(() {
                _startDate = _tmpStartDate;
              });
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<Null> _setEndDate(context) async {
    return showDialog(
      context: context,
      child: AlertDialog(
        content: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _endDate,
            onDateTimeChanged: (DateTime value) {
              _tmpEndDate = value;
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Confirm'),
            onPressed: () {
              if (_startDate.millisecondsSinceEpoch >
                  _tmpEndDate.millisecondsSinceEpoch) {
                setState(() {
                  _tmpEndDate = _endDate;
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('End date should be greater than start date'),
                ));
              } else {
                setState(() {
                  _endDate = _tmpEndDate;
                });
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  _buildJobInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Title",
            ),
            controller: _jobTitleTextController,
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
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Company",
            ),
            controller: _jobWhereTitleTextController,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text(
            'Please add information about the company',
          ),
        ),
        GestureDetector(
          onTap: () {
            _setStartDate(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(DateFormat.yMMMM()
                .format(DateTime.fromMicrosecondsSinceEpoch(
                    _startDate.millisecondsSinceEpoch * 1000))
                .toString()),
          ),
        ),
        GestureDetector(
          onTap: () {
            _setStartDate(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              'Please add information about the start period',
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _setEndDate(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(DateFormat.yMMMM()
                .format(DateTime.fromMicrosecondsSinceEpoch(
                    _endDate.millisecondsSinceEpoch * 1000))
                .toString()),
          ),
        ),
        GestureDetector(
          onTap: () {
            _setEndDate(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              'Please add information about the end period',
            ),
          ),
        )
      ],
    );
  }

  _save() async {
    setState(() => _isDirty = false);
    if (widget.editing) {
      final index = widget.user.jobHistories.indexWhere(
        (jobHistory) => jobHistory.uid == widget.jobHistoryUID,
      );
      widget.user.jobHistories.replaceRange(index, index + 1, [
        JobHistory(
          jobTitle: _jobTitleTextController.text,
          jobWhere: _jobWhereTitleTextController.text,
          startDate: Timestamp.fromDate(_startDate),
          endDate: Timestamp.fromDate(_endDate),
          isCurrent: false,
        )
      ]);
    } else {
      widget.user.jobHistories.add(JobHistory(
        jobTitle: _jobTitleTextController.text,
        jobWhere: _jobWhereTitleTextController.text,
        startDate: Timestamp.fromDate(_startDate),
        endDate: Timestamp.fromDate(_endDate),
        isCurrent: false,
      ));
    }

    await widget.userBloc
        .updateJobHistories(widget.user.id, widget.user.jobHistories);
  }

  _remove() async {
    setState(() => _isDirty = false);

    final index = widget.user.jobHistories.indexWhere(
      (jobHistory) => jobHistory.jobTitle == widget.jobTitle,
    );
    widget.user.jobHistories.removeAt(index);

    await widget.userBloc
        .updateJobHistories(widget.user.id, widget.user.jobHistories);
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
            'Remove this job history?',
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
