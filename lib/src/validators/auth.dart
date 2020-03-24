import 'dart:async';

import 'package:vouched/src/constants/auth.dart';

class AuthValidators {
  static final email =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError(AuthConstants.errorEmail);
    }
  });

  static final phone =
  StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (RegExp(r"^(?:[+0]+)?[0-9]{6,14}$").hasMatch(phone)) {
      sink.add(phone);
    } else {
      sink.addError(AuthConstants.errorPhone);
    }
  });
}
