import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vouched/src/constants/auth.dart';
import 'package:vouched/src/resources/firebase_auth/repository.dart';
import 'package:vouched/src/validators/auth.dart';

class AuthFirebaseBloc implements Bloc {
  final _firebaseAuthRepository = FirebaseAuthRepository();
  final _dialCode = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();

// Add data to stream, validate inputs
  Stream<String> get phone => _phone.stream.transform(AuthValidators.phone);
  Stream<String> get dialCode => _dialCode.stream;

// get value
  String get getPhone => _phone.value;
  String get getDialCode => _dialCode.value;

// change data
  Function(String) get changePhone => _phone.sink.add;
  Function(String) get changeDialCode => _dialCode.sink.add;

// remove accidental spaces from the input
  Future<void> sendSignInWithEmailLink(email) {
    return _firebaseAuthRepository
        .sendSignInWithEmailLink(email.value.replaceAll(" ", ""));
  }

  Future<AuthResult> signInWIthEmailLink(email, link) {
    return _firebaseAuthRepository.signInWithEmailLink(email, link);
  }

  Future<FirebaseUser> getCurrentUser() {
    return _firebaseAuthRepository.getCurrentUser();
  }

  Future<void> signOut() {
    return _firebaseAuthRepository.signOut();
  }

  Future<AuthResult> signInWithCredential(AuthCredential credential) {
    return _firebaseAuthRepository.signInWithCredential(credential);
  }

  Future<void> authenticateAnonymousUser() {
    return _firebaseAuthRepository.signInAnonymousUser();
  }

  Future<void> verifyPhoneNumber(
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
      PhoneCodeSent codeSent,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed) {
    // For the full phone number we need to concat the dialcode and the number entered by the user
    String phoneNumber = _dialCode.value + _phone.value.replaceAll(" ", "");
    return _firebaseAuthRepository.verifyPhoneNumber(
        phoneNumber,
        codeAutoRetrievalTimeout,
        codeSent,
        Duration(seconds: AuthConstants.timeOutDuration),
        verificationCompleted,
        verificationFailed);
  }

  dispose() async {
    await _dialCode.drain();
    _dialCode.close();
    await _phone.drain();
    _phone.close();
  }
}
