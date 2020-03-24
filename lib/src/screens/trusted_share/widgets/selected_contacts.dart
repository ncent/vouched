import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';
import 'package:vouched/src/models/user.dart';

typedef OnSelectedContactRemoved(TrustedContact contact);

class SelectedContacts extends StatelessWidget {
  final List<TrustedContact> contactsChecked;
  final OnSelectedContactRemoved onSelectedContactRemoved;

  SelectedContacts({
    @required this.contactsChecked,
    this.onSelectedContactRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Tags(
        key: _tagStateKey,
        itemCount: contactsChecked.length,
        itemBuilder: (index) {
          final item = contactsChecked[index];
          final avatar = item.avatar;

          final circleAvatar = (avatar != null && avatar.length > 0)
              ? CircleAvatar(backgroundImage: MemoryImage(avatar))
              : CircleAvatar(
                  child: Text((item.initials().toUpperCase()),
                      style: TextStyle(color: Colors.white)),
                );

          return ItemTags(
            removeButton: ItemTagsRemoveButton(
              backgroundColor: Colors.green[900],
            ),
            onRemoved: () {
              onSelectedContactRemoved?.call(item);
            },
            index: index,
            title: item.displayName,
            image: ItemTagsImage(
              child: circleAvatar,
            ),
          );
        });
  }
}

final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
