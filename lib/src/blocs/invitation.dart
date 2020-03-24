import 'package:bloc_provider/bloc_provider.dart';
import 'package:vouched/src/models/invitation.dart';
import 'package:vouched/src/resources/firestore/invitation/repository.dart';

class InvitationBloc implements Bloc {
  final _invitationRepository = InvitationRepository();

  Future<Invitation> create(Invitation invitation) =>
      _invitationRepository.create(invitation);

  dispose() async {}
}
