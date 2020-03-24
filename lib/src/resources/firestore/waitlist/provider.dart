import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/waitlist.dart';

class WaitListProvider {
  final CollectionReference waitListCollection =
      Firestore.instance.collection('waitlist');

  Future<WaitList> create(WaitList waitlist) async {
    waitListCollection.document(waitlist.id).setData(waitlist.toJson());
    return Future.value(waitlist);
  }

  Future<void> approveUserById(String documentID) {
    return waitListCollection
        .document(documentID)
        .updateData({'approved': true});
  }

  Stream<QuerySnapshot> waitListAll() {
    return waitListCollection.getDocuments().asStream();
  }

  Stream<QuerySnapshot> waitListAllApproved(bool isApproved) {
    return waitListCollection
        .where('approved', isEqualTo: isApproved)
        .snapshots();
  }

  Future<DocumentSnapshot> waitListUserById(String uid) {
    return waitListCollection.document(uid).get();
  }

  Stream<QuerySnapshot> waitListUserByPhone(String phone) {
    return waitListCollection.where('phone', isEqualTo: phone).snapshots();
  }

  Stream<QuerySnapshot> waitListUserByEmail(String email) {
    return waitListCollection.where('email', isEqualTo: email).snapshots();
  }
}
