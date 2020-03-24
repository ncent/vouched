import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/waitlist.dart';
import 'package:vouched/src/resources/firestore/waitlist/repository.dart';

class WaitListBloc implements Bloc {
  final _waitListRepository = WaitListRepository();

  Future<WaitList> create(WaitList wailList) =>
      _waitListRepository.create(wailList);

  Future<void> approveUserById(String documentID) =>
      _waitListRepository.approveUserById(documentID);

  Stream<QuerySnapshot> waitListAll() => _waitListRepository.waitListAll();

  Stream<QuerySnapshot> waitListAllApproved(bool isApproved) =>
      _waitListRepository.waitListAllApproved(isApproved);

  Future<DocumentSnapshot> waitListUserById(String uid) =>
      _waitListRepository.waitListUserById(uid);

  Stream<QuerySnapshot> waitListUserByPhone(String phone) =>
      _waitListRepository.waitListUserByPhone(phone);

  Stream<QuerySnapshot> waitListUserByEmail(String email) =>
      _waitListRepository.waitListUserByEmail(email);

  dispose() async {}
}
