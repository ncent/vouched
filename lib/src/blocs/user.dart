import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/resources/firebase_auth/repository.dart';
import 'package:vouched/src/resources/firestore/user/repository.dart';

class UserBloc implements Bloc {
  final _userRepository = UserRepository();
  final _firebaseAuthRepository = FirebaseAuthRepository();

  Future<User> create(User user) => _userRepository.create(user);

  Future<void> update(User user) => _userRepository.update(user);

  Future<User> findOrCreate(User user) => _userRepository.findOrCreate(user);

  Future<List<User>> findOrCreateAll(List<User> users) =>
      _userRepository.findOrCreateAll(users);

  Future<User> getCurrentUser() async {
    final currUser = await _firebaseAuthRepository.getCurrentUser();
    final userData = await userById(currUser.uid);

    if (userData.data != null) {
      return Future.value(new User.fromJson(userData.data));
    } else {
      return Future.value(new User());
    }
  }

  Future<User> getCurrentUserById(uid) async {
    final userData = await userById(uid);

    if (userData.data != null) {
      return Future.value(new User.fromJson(userData.data));
    } else {
      return Future.value(new User());
    }
  }

  Future<DocumentSnapshot> userById(String uid) =>
      _userRepository.userById(uid);

  Stream<DocumentSnapshot> userByIdAsStream(String uid) =>
      _userRepository.userByIdAsStream(uid);

  Stream<QuerySnapshot> userByPhone(String phone) =>
      _userRepository.userByPhone(phone);

  Stream<QuerySnapshot> userByEmail(String email) =>
      _userRepository.userByEmail(email);

  Future<void> updateJobHistories(String uid, List<JobHistory> jobHistories) {
    return _userRepository.updateJobHistories(uid, jobHistories);
  }

  Future<void> updateSkills(String uid, List<Skill> skills) {
    return _userRepository.updateSkills(uid, skills);
  }

  Future<void> updateTrustedContacts(
      String uid, List<TrustedContact> trustedContacts) {
    return _userRepository.updateTrustedContacts(uid, trustedContacts);
  }

  dispose() async {}
}
