import 'package:firebase_auth/firebase_auth.dart';
import 'package:vouched/src/constants/auth.dart';

class FirebaseAuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendSignInWithEmailLink(String email) async {
    return _auth.sendSignInWithEmailLink(
        email: email,
        url: AuthConstants.projectUrl,
        androidInstallIfNotAvailable: true,
        androidMinimumVersion: '21',
        // TODO: replace name
        androidPackageName: 'com.example.passwordlessdemo',
        handleCodeInApp: true,
        // TODO: replace id
        iOSBundleID: 'com.lostcoders.vouched');
  }

  Future<AuthResult> signInWithEmailLink(String email, String link) async {
    return _auth.signInWithEmailAndLink(email: email, link: link);
  }

  Future<void> verifyPhoneNumber(
      String phone,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
      PhoneCodeSent codeSent,
      Duration duration,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed) async {
    return _auth.verifyPhoneNumber(
        phoneNumber: phone,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        codeSent: codeSent,
        timeout: duration,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed);
  }

  Future<AuthResult> signInWithCredential(AuthCredential credential) async {
    return _auth.signInWithCredential(credential);
  }

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

  Future<void> signInAnonymousUser() {
    return _auth.signInAnonymously();
  }
}
