import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/waitlist.dart';
import 'package:vouched/src/resources/firestore/waitlist/provider.dart';

class WaitListRepository {
  final _waitListProvider = WaitListProvider();

  Future<WaitList> create(WaitList waitList) =>
      _waitListProvider.create(waitList);

  Future<void> approveUserById(String documentID) =>
      _waitListProvider.approveUserById(documentID);

  Stream<QuerySnapshot> waitListAll() => _waitListProvider.waitListAll();

  Stream<QuerySnapshot> waitListAllApproved(bool isApproved) =>
      _waitListProvider.waitListAllApproved(isApproved);

  Future<DocumentSnapshot> waitListUserById(String uid) =>
      _waitListProvider.waitListUserById(uid);

  Stream<QuerySnapshot> waitListUserByPhone(String phone) =>
      _waitListProvider.waitListUserByPhone(phone);

  Stream<QuerySnapshot> waitListUserByEmail(String email) =>
      _waitListProvider.waitListUserByEmail(email);
}
