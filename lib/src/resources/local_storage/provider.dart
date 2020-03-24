import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

/// Used to store and retrieve the user email address and phone
class LocalStorageProvider {
  LocalStorageProvider({@required this.flutterSecureStorage})
      : assert(flutterSecureStorage != null);

  final FlutterSecureStorage flutterSecureStorage;

  static const String storageUserEmailKey = 'userEmailAddress';
  static const String storageUserIdKey = 'userId';
  static const String storageIsAnonymousKey = 'isAnonymous';
  static const String storageTrustedContactsKey = 'trustedContacts';

  // email
  Future<void> setEmail(String email) async {
    await flutterSecureStorage.write(key: storageUserEmailKey, value: email);
  }

  // email
  Future<void> setUid(String uid) async {
    await flutterSecureStorage.write(key: storageUserIdKey, value: uid);
  }

  Future<void> clearEmail() async {
    await flutterSecureStorage.delete(key: storageUserEmailKey);
  }

  Future<String> getEmail() async {
    return await flutterSecureStorage.read(key: storageUserEmailKey);
  }

  Future<String> getUid() async {
    return await flutterSecureStorage.read(key: storageUserIdKey);
  }

  Future<void> setIsAnonymous(bool isAnonymous) async {
    await flutterSecureStorage.write(
        key: storageIsAnonymousKey, value: isAnonymous.toString());
  }

  Future<bool> getIsAnonymous() async {
    return (await flutterSecureStorage.read(key: storageIsAnonymousKey))
            .toLowerCase() ==
        'true';
  }
}
