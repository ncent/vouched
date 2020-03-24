import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/resources/firestore/user/provider.dart';

class UserRepository {
  final _userProvider = UserProvider();

  Future<User> create(User user) => _userProvider.create(user);

  Future<void> update(User user) => _userProvider.update(user);

  Future<User> findOrCreate(User user) => _userProvider.findOrCreate(user);

  Future<List<User>> findOrCreateAll(List<User> users) =>
      _userProvider.findOrCreateAll(users);

  Future<DocumentSnapshot> userById(String uid) => _userProvider.userById(uid);

  Stream<DocumentSnapshot> userByIdAsStream(String uid) =>
      _userProvider.userByIdAsStream(uid);

  Stream<QuerySnapshot> userByPhone(String phone) =>
      _userProvider.userByPhone(phone);

  Stream<QuerySnapshot> userByEmail(String email) =>
      _userProvider.userByEmail(email);

  Future<void> updateJobHistories(String uid, List<JobHistory> jobHistories) =>
      _userProvider.updateJobHistories(uid, jobHistories);

  Future<void> updateSkills(String uid, List<Skill> skills) =>
      _userProvider.updateSkills(uid, skills);

  Future<void> updateTrustedContacts(
          String uid, List<TrustedContact> trustedContacts) =>
      _userProvider.updateTrustedContacts(uid, trustedContacts);
}
