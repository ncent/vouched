import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/waitlist.dart';
import 'package:vouched/src/models/waitlist.dart';

approvalDialog(
    BuildContext context, WaitList waitListUser, WaitListBloc waitListBloc) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("User: " + waitListUser.id),
          content: Text("Would you like to approve this user?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Approve"),
              onPressed: () async {
                await waitListBloc.approveUserById(waitListUser.id);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
