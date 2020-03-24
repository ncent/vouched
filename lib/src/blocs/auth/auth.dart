import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:vouched/src/blocs/auth/auth_firebase.dart';
import 'package:vouched/src/blocs/auth/auth_local.dart';

// Define all possible states for the auth form.
enum AuthStatus {
  anonymous,
  emailAuth,
  phoneAuth,
  emailLinkSent,
  smsSent,
  isLoading,
  completed
}

class AuthBloc with AuthFirebaseBloc, AuthLocalBloc {
  final _authStatus = BehaviorSubject<AuthStatus>();
  final _verificationId = BehaviorSubject<String>();

  Stream<AuthStatus> get authStatus => _authStatus.stream;
  Stream<String> get verificationId => _verificationId.stream;

  AuthStatus get getAuthStatus => _authStatus.value;
  String get getVerificationId => _verificationId.value;

  Function(AuthStatus) get changeAuthStatus => _authStatus.sink.add;
  Function(String) get changeVerificationId => _verificationId.sink.add;

  AuthBloc() {
    _authStatus.add(AuthStatus.anonymous);
  }

  dispose() async {
    await _authStatus.drain();
    _authStatus.close();
    await _verificationId.drain();
    _verificationId.close();
  }
}
