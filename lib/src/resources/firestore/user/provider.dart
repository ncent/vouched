import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/user.dart';

class UserProvider {
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  // TODO validate uniqueness
  Future<User> create(User user) async {
    userCollection.document(user.id).setData(user.toJson());
    return Future.value(user);
  }

  // TODO validate uniqueness and updates
  Future<void> update(User user) async {
    return userCollection.document(user.id).updateData(user.toJson());
  }

  Future<User> findOrCreate(User user) async {
    if (user.email != null) {
      var doc = await userCollection
          .where('email', isEqualTo: user.email)
          .getDocuments();
      if (doc.documents.length == 1)
        return User.fromJson(doc.documents.first.data);
    }
    if (user.phone != null) {
      var doc = await userCollection
          .where('phone', isEqualTo: user.phone)
          .getDocuments();
      if (doc.documents.length == 1)
        return User.fromJson(doc.documents.first.data);
    }
    var documentReference = await userCollection.add(user.toJson());
    user.id = documentReference.documentID;
    return user;
  }

  Future<List<User>> findOrCreateAll(List<User> users) async {
    var resultUsers = Set<User>();
    var userEmails =
        users.where((u) => u.email != null).map((u) => u.email).toList();
    var userPhones =
        users.where((u) => u.phone != null).map((u) => u.phone).toList();
    var snapshots = List();

    if (userEmails.isNotEmpty)
      snapshots.addAll((await userCollection
              .where('email', whereIn: userEmails)
              .getDocuments())
          .documents);

    if (userPhones.isNotEmpty)
      snapshots.addAll((await userCollection
              .where('phone', whereIn: userPhones)
              .getDocuments())
          .documents);

    if (snapshots.isNotEmpty)
      for (var snapshot in snapshots)
        resultUsers.add(User.fromJson(snapshot.data));

    var foundEmails = resultUsers.map((u) => u.email).toList();
    var foundPhones = resultUsers.map((u) => u.phone).toList();
    var remainingToCreate = users.where((u) =>
        !foundEmails.contains(u.email) && !foundPhones.contains(u.phone));

    for (var remainingUser in remainingToCreate) {
      var documentReference = await userCollection.add(remainingUser.toJson());
      remainingUser.id = documentReference.documentID;
      resultUsers.add(remainingUser);
    }

    return resultUsers.toList();
  }

  Future<DocumentSnapshot> userById(String documentID) {
    return userCollection.document(documentID).get();
  }

  Stream<DocumentSnapshot> userByIdAsStream(String documentID) {
    return userCollection.document(documentID).snapshots();
  }

  Stream<QuerySnapshot> userByPhone(String phone) {
    return userCollection.where('phone', isEqualTo: phone).snapshots();
  }

  Stream<QuerySnapshot> userByEmail(String email) {
    return userCollection.where('email', isEqualTo: email).snapshots();
  }

  Future<void> updateJobHistories(String uid, List<JobHistory> jobHistories) {
    return userCollection.document(uid).updateData({
      "jobHistories":
          jobHistories.map((jobHistory) => jobHistory.toJson()).toList()
    });
  }

  Future<void> updateSkills(String uid, List<Skill> skills) {
    return userCollection
        .document(uid)
        .updateData({"skills": skills.map((skill) => skill.toJson()).toList()});
  }

  Future<void> updateTrustedContacts(
      String uid, List<TrustedContact> trustedContacts) {
    return userCollection.document(uid).updateData({
      "trustedContacts":
          trustedContacts.map((contact) => contact.toMap()).toList()
    });
  }
}
