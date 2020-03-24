import 'package:flutter/material.dart';
import 'package:vouched/src/screens/widgets/vicons.dart';

const SuggestIconColor = 0xff57aff5;

typedef OnTapSuggestedFilter();
typedef OnDismissSuggestedFilter();

class SuggestedTile extends StatelessWidget {
  final bool isSuggestedSent;
  final OnTapSuggestedFilter onTapSuggestedFilter;
  final OnDismissSuggestedFilter onDismissSuggestedFilter;

  const SuggestedTile({
    Key key,
    this.isSuggestedSent,
    this.onTapSuggestedFilter,
    this.onDismissSuggestedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isSuggestedSent != null && isSuggestedSent,
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
            onDismissSuggestedFilter?.call();
            return false;
          },
          child: isSuggestedSent == null || !isSuggestedSent
              ? ListTile(
                  onTap: () => onTapSuggestedFilter?.call(),
                  subtitle: Text("Your magical suggestion"),
                  enabled: true,
                  title: Text('Suggested'),
                  leading: Icon(
                    Icons.star,
                    size: 50,
                    color: Color(SuggestIconColor),
                  ),
                )
              : ListTile(
                  onTap: () => onTapSuggestedFilter?.call(),
                  trailing: Icon(
                    Icons.done,
                  ),
                  subtitle: Text("Your magical suggestion is sent"),
                  enabled: false,
                  title: Text('Suggested'),
                  leading: Icon(
                    Icons.star,
                    size: 50,
                  ),
                )),
    );
  }
}
