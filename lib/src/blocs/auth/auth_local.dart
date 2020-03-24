import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vouched/src/resources/local_storage/repository.dart';
import 'package:vouched/src/validators/auth.dart';

class AuthLocalBloc implements Bloc {
  final _localStorageRepository = LocalStorageRepository();
  final _email = BehaviorSubject<String>();
  final _uid = BehaviorSubject<String>();
  final _isAnonymous = BehaviorSubject<bool>();

  // Add data to stream, validate inputs
  Stream<String> get email => _email.stream.transform(AuthValidators.email);
  Stream<String> get uid => _uid.stream;
  Stream<bool> get isAnonymous => _isAnonymous.stream;

  // get value
  String get getEmail => _email.value;
  String get getUid => _uid.value;
  bool get getIsAnonymous => _isAnonymous.value;

  // change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changeUid => _uid.sink.add;

  Function(bool) get changeIsAnonymous => _isAnonymous.sink.add;

  Future<void> storeUserEmail() {
    return _localStorageRepository.setEmail(_email.value.replaceAll(" ", ""));
  }

  Future<void> storeUid() {
    return _localStorageRepository.setUid(_uid.value);
  }

  Future<void> storeIsAnonymous() {
    return _localStorageRepository.setIsAnonymous(_isAnonymous.value);
  }

  Future<void> clearUserEmailFromStorage() {
    return _localStorageRepository.clearEmail();
  }

  Future<String> getUserEmailFromStorage() {
    return _localStorageRepository.getEmail();
  }

  Future<String> getUserIdFromStorage() {
    return _localStorageRepository.getUid();
  }

  Future<bool> getIsAnonymousFromStorage() {
    return _localStorageRepository.getIsAnonymous();
  }

  dispose() async {
    await _email.drain();
    _email.close();
    await _uid.drain();
    _uid.close();
    await _isAnonymous.drain();
    _isAnonymous.close();
  }
}
