import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/invitation.dart';

class InvitationProvider {
  final CollectionReference invitationCollection =
      Firestore.instance.collection('invitations');

  Future<Invitation> create(Invitation invitation) async {
    invitationCollection.document(invitation.id).setData(invitation.toJson());
    return Future.value(invitation);
  }
}
