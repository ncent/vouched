import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouched/src/blocs/waitlist.dart';
import 'package:vouched/src/models/waitlist.dart';
import 'package:vouched/src/screens/waitlist_dashboard/approval_dialog.dart';

class WaitListDashboard extends StatefulWidget {
  @override
  WaitListDashboardState createState() {
    return WaitListDashboardState();
  }
}

class WaitListDashboardState extends State<WaitListDashboard> {
  WaitListBloc _waitListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _waitListBloc = BlocProvider.of<WaitListBloc>(context);
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _waitListBloc.waitListAllApproved(false),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
              appBar: AppBar(
                title: const Text("Wait List"),
              ),
              body: Center(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  final waitListUser =
                      WaitList.fromJson(snapshot.data.documents[index].data);

                  return ListTile(
                    onTap: () =>
                        approvalDialog(context, waitListUser, _waitListBloc),
                    title: Text("Phone: " + waitListUser.phone),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Auth ID: " + waitListUser.id),
                        Text("Created At: " +
                            DateFormat.yMMMMEEEEd().format(
                                DateTime.fromMicrosecondsSinceEpoch(waitListUser
                                        .createdAt.millisecondsSinceEpoch *
                                    1000))),
                      ],
                    ),
                    enabled: true,
                  );
                },
                itemCount: snapshot.data.documents.length,
              )));
        });
  }
}
