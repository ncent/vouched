import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vouched/src/resources/local_storage/provider.dart';

class LocalStorageRepository {
  final _store =
      LocalStorageProvider(flutterSecureStorage: new FlutterSecureStorage());

  Future<void> setEmail(String email) => _store.setEmail(email);

  Future<void> setUid(String uid) => _store.setUid(uid);

  Future<void> setIsAnonymous(bool isAnonymous) =>
      _store.setIsAnonymous(isAnonymous);

  Future<void> clearEmail() => _store.clearEmail();

  Future<String> getEmail() => _store.getEmail();

  Future<String> getUid() => _store.getUid();

  Future<bool> getIsAnonymous() => _store.getIsAnonymous();
}
