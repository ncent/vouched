import 'package:flutter/material.dart';
import 'package:vouched/src/screens/widgets/vicons.dart';

const AllIconColor = 0xff57aff5;

typedef OnTapAllFilter();
typedef OnDismissAllFilter();

class AllTile extends StatelessWidget {
  final bool isAllSent;
  final OnTapAllFilter onTapAllFilter;
  final OnDismissAllFilter onDismissAllFilter;

  const AllTile({
    Key key,
    this.isAllSent,
    this.onTapAllFilter,
    this.onDismissAllFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isAllSent != null && isAllSent,
      child: Dismissible(
        direction: DismissDirection.startToEnd,
        key: UniqueKey(),
        background: Container(
          padding: EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              VIcons.share,
              color: Colors.white,
            ),
          ),
          color: Colors.green,
        ),
        confirmDismiss: (_) async {
          onDismissAllFilter?.call();
          return false;
        },
        child: isAllSent == null || !isAllSent
            ? ListTile(
                onTap: () => onTapAllFilter?.call(),
                subtitle: Text("Everyone on the list"),
                enabled: true,
                title: Text('All'),
                leading: Icon(
                  Icons.person,
                  size: 50,
                  color: Color(AllIconColor),
                ),
              )
            : ListTile(
                onTap: () => onTapAllFilter?.call(),
                trailing: Icon(
                  Icons.done,
                ),
                subtitle: Text("Sent to everyone on the list"),
                enabled: false,
                title: Text('All'),
                leading: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
      ),
    );
  }
}
