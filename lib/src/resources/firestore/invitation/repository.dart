import 'package:vouched/src/models/invitation.dart';
import 'package:vouched/src/resources/firestore/invitation/provider.dart';

class InvitationRepository {
  final _invitationProvider = InvitationProvider();

  Future<Invitation> create(Invitation invitation) =>
      _invitationProvider.create(invitation);
}
