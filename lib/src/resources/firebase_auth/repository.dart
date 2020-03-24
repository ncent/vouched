import 'package:firebase_auth/firebase_auth.dart';
import 'package:vouched/src/resources/firebase_auth/provider.dart';

class FirebaseAuthRepository {
  final _authController = FirebaseAuthProvider();

  Future<void> sendSignInWithEmailLink(String email) =>
      _authController.sendSignInWithEmailLink(email);

  Future<AuthResult> signInWithEmailLink(String email, String link) =>
      _authController.signInWithEmailLink(email, link);

  Future<AuthResult> signInWithCredential(AuthCredential credential) =>
      _authController.signInWithCredential(credential);

  Future<FirebaseUser> getCurrentUser() => _authController.getCurrentUser();

  Future<void> signOut() => _authController.signOut();

  Future<void> verifyPhoneNumber(
          String phone,
          PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
          PhoneCodeSent codeSent,
          Duration duration,
          PhoneVerificationCompleted verificationCompleted,
          PhoneVerificationFailed verificationFailed) =>
      _authController.verifyPhoneNumber(phone, codeAutoRetrievalTimeout,
          codeSent, duration, verificationCompleted, verificationFailed);

  Future<void> signInAnonymousUser() => _authController.signInAnonymousUser();
}
