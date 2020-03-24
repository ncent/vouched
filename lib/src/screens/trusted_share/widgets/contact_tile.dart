import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/screens/trusted_share/widgets/contact_avatar.dart';
import 'package:vouched/src/screens/widgets/vicons.dart';

typedef OnSendInvitationToSingleContact(TrustedContact contact);
typedef OnRemoveFromTrustedContacts(TrustedContact contact);

class ContactTile extends StatelessWidget {
  final TrustedContact contact;
  final OnSendInvitationToSingleContact onSendInvitationToSingleContact;
  final OnRemoveFromTrustedContacts onRemoveFromTrustedContacts;
  final Uint8List avatar;
  final bool enabled;
  final bool isSuggested;

  ContactTile({
    @required this.contact,
    this.onSendInvitationToSingleContact,
    this.onRemoveFromTrustedContacts,
    this.avatar,
    this.enabled,
    this.isSuggested = false,
  });

  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: Dismissible(
          direction: !isSuggested
              ? DismissDirection.startToEnd
              : DismissDirection.horizontal,
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
          secondaryBackground: Container(
            padding: EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.white,
              ),
            ),
            color: Colors.red,
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              onSendInvitationToSingleContact?.call(contact);
            } else if (direction == DismissDirection.endToStart) {
              onRemoveFromTrustedContacts?.call(contact);
            }
            return false;
          },
          child: ListTile(
            trailing: !enabled
                ? Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Column(children: <Widget>[
                      Icon(
                        Icons.done,
                      ),
                      Text('Sent')
                    ]),
                  )
                : null,
            leading: ContactAvatar(
              isSuggestedAvatar: isSuggested,
              avatar: avatar,
              initials: contact.initials(),
            ),
            title: Text(contact.displayName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(contact.phones.map((p) => p.value).elementAt(0)),
              ],
            ),
            enabled: enabled,
          )),
    );
  }
}
