import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/screens/profile/widgets/job_history/job_history_edit.dart';

class JobHistoryPage extends StatelessWidget {
  final UserBloc userBloc;
  final User user;
  final bool allowUserEdit;

  const JobHistoryPage({
    @required this.userBloc,
    @required this.user,
    @required this.allowUserEdit,
  });

  @override
  Widget build(BuildContext context) {
    final jobList = user.jobHistories.map((job) {
      return GestureDetector(
        onTap: () => _editJobHistory(context, job),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              job.jobTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              job.jobWhere,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),
            Text(
              _formatDate(job.startDate, job.endDate),
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),
            user.jobHistories.last != job ? Divider() : Container(),
          ],
        ),
      );
    }).toList();

    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: 20,
            ),
            child: Text('Job History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
          if (user.jobHistories == null || user.jobHistories.isEmpty)
            Center(
              child: Text(
                allowUserEdit
                    ? 'No job history added yet, click on + button to add a new job history'
                    : 'This user have no job history added yet',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          if (user.jobHistories != null && user.jobHistories.isNotEmpty)
            ...jobList
        ],
      ),
    );
  }

  _formatDate(startDate, endDate) {
    return [
      DateFormat.yMMMM()
          .format(DateTime.fromMicrosecondsSinceEpoch(
              startDate.millisecondsSinceEpoch * 1000))
          .toString(),
      if (endDate != null)
        ' to ' +
            DateFormat.yMMMM()
                .format(DateTime.fromMicrosecondsSinceEpoch(
                    endDate.millisecondsSinceEpoch * 1000))
                .toString()
    ].join('');
  }

  _editJobHistory(context, JobHistory job) {
    return Navigator.of(context).push(
      PageRouterJobHistory(
        jobHistoryUID: job.uid,
        user: user,
        userBloc: userBloc,
        title: 'Edit Job',
        jobTitle: job.jobTitle,
        jobWhereTitle: job.jobWhere,
        jobStart: job.startDate != null ? job.startDate.toDate() : null,
        jobEnd: job.endDate != null ? job.endDate.toDate() : null,
        info: "You can edit information about your past or current job.",
        warning: "Are you sure you want to exit without save?",
        editing: true,
      ),
    );
  }
}
