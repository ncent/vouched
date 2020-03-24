import 'package:bloc_provider/bloc_provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:pin_view/pin_view.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/blocs/waitlist.dart';
import 'package:vouched/src/constants/auth.dart';
import 'package:vouched/src/constants/global.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/models/waitlist.dart';
import 'package:vouched/src/routes.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  AuthBloc _bloc;
  UserBloc _userBloc;
  WaitListBloc _waitListBloc;
  Locale _myLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<AuthBloc>(context);
    _waitListBloc = BlocProvider.of<WaitListBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    this.initDynamicLinks();
    _myLocale = Localizations.localeOf(context);

    /// We need to reflect the initial selection of the dialcode, in case the phone's selected locale
    /// matches the phone dial code, which is the majority of the cases.
    /// We do this by loading up a list of dialcodes and their respected country code, from there
    /// we find the matching dialcode for the phone's locale.
    List<CountryCode> elements = codes
        .map((s) => CountryCode(
              name: "",
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: "",
            ))
        .toList();
    String dialCode =
        elements.firstWhere((c) => c.code == _myLocale.countryCode).dialCode;
    _bloc.changeDialCode(dialCode);
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      /// Change status to a loading state, so user would not get confused even for a second.
      _bloc.changeAuthStatus(AuthStatus.isLoading);
      _bloc
          .signInWIthEmailLink(
              await _bloc.getUserEmailFromStorage(), deepLink.toString())
          .whenComplete(() => _authCompleted(Routes.DashboardPath));
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    _waitListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 32, right: 32, bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: _bloc.authStatus,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case (AuthStatus.emailAuth):
                    return _authForm(true);
                    break;
                  case (AuthStatus.phoneAuth):
                    return _authForm(false);
                    break;
                  case (AuthStatus.emailLinkSent):
                    return Center(child: Text(AuthConstants.sentEmail));
                    break;
                  case (AuthStatus.smsSent):
                    return _smsCodeInputField();
                    break;
                  case (AuthStatus.isLoading):
                    return _buildCircularProgressBar();
                    break;
                  case (AuthStatus.completed):
                    return _buildCircularProgressBar();
                    break;
                  case (AuthStatus.anonymous):
                    _authenticateAnonymousUser().whenComplete(
                        () => {_authCompleted(Routes.DashboardPath)});
                    return _buildCircularProgressBar();
                    break;
                  default:
                    return _landing();
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _landing() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          RaisedButton(
            onPressed: () => _bloc.changeAuthStatus(AuthStatus.emailAuth),
            child: Text('Sign In/Up'),
          ),
          RaisedButton(
            onPressed: () => _bloc.changeAuthStatus(AuthStatus.anonymous),
            child: Text('Enter as a Guest'),
          ),
        ]));
  }

  _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.close),
          onPressed: () {
            _bloc.changeAuthStatus(AuthStatus.anonymous);
          },
        )
      ],
    );
  }

  _buildCircularProgressBar() {
    return Center(child: CircularProgressIndicator());
  }

  /// Widget is specfied for auth method by [isEmail] value.
  /// If its false, a form for phone auth is given.
  /// This is to make it easier for the email and phone auth forms to be more similar looking.
  /// Keeping that in mind we'll try to share all the widgets to a reasonable extent.
  Widget _authForm(bool isEmail) {
    return StreamBuilder(
        stream: isEmail ? _bloc.email : _bloc.phone,
        builder: (context, snapshot) {
          return Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: 24,
              ),
              child: Text(
                isEmail
                    ? "Enter your email to signup"
                    : "Enter your phone to signup",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            isEmail
                ? _emailInputField(snapshot.error)
                : _phoneInputField(snapshot.error),
            SizedBox(height: 32),
            RaisedButton(
              onPressed: snapshot.hasData
                  ? (isEmail
                      ? _authenticateUserWithEmail
                      : _authenticateUserWithPhone)
                  : null,
              child: Text(
                AuthConstants.submit.toUpperCase(),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            // **** Temporarily remove email sign in (phone only) ****
            /* SizedBox(height: 32),
            GestureDetector(
                onTap: () => _bloc.changeAuthStatus(
                    isEmail ? AuthStatus.phoneAuth : AuthStatus.emailAuth),
                child: Text(
                  isEmail
                      ? AuthConstants.usePhone.toUpperCase()
                      : AuthConstants.useEmail.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),*/
          ]);
        });
  }

  /// The method takes in an [error] message from our validator.
  Widget _emailInputField(String error) {
    return TextField(
      onChanged: _bloc.changeEmail,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        hintText: AuthConstants.enterEmail,
        errorText: error,
        labelText: AuthConstants.labelEmail,
        labelStyle: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  /// Besides the user entering their phone number, we also need to know the user's country code
  /// for that we are gonna use a library CountryCodePicker.
  /// The method takes in an [error] message from our validator.
  Widget _phoneInputField(String error) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: CountryCodePicker(
                onChanged: (countryCode) =>
                    _bloc.changeDialCode(countryCode.dialCode),
                initialSelection: _myLocale.countryCode,
                favorite: [_myLocale.countryCode],
                showCountryOnly: false,
                alignLeft: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: _bloc.changePhone,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: AuthConstants.enterPhone,
                errorText: error,
                labelText: AuthConstants.labelPhone,
                labelStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smsCodeInputField() {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(
          bottom: 24,
        ),
        child: Text(
          "Please confirm the SMS code sent to phone " + _bloc.getPhone,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      PinView(
          count: 6, // describes the field number
          margin: EdgeInsets.all(2.5), // margin between the fields
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          autoFocusFirstField: true,
          inputDecoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
          submit: (String smsCode) {
            AuthCredential credential = PhoneAuthProvider.getCredential(
                verificationId: _bloc.getVerificationId, smsCode: smsCode);
            _bloc.signInWithCredential(credential).then((result) =>
                // You could potentially find out if the user is new
                // and if so, pass that info on, to maybe do a tutorial
                // if (result.additionalUserInfo.isNewUser)
                _authCompleted(Routes.DashboardPath));
          }),
      Container(
        margin: EdgeInsets.only(
          top: 12,
        ),
        child: Text(
          "Enter 6-digit code",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    ]);
  }

  Future<void> _authenticateAnonymousUser() {
    return _bloc.authenticateAnonymousUser();
  }

  void _authenticateUserWithEmail() {
    _bloc.sendSignInWithEmailLink(_bloc.getEmail).whenComplete(() => _bloc
        .storeUserEmail()
        .whenComplete(() => _bloc.changeAuthStatus(AuthStatus.emailLinkSent)));
  }

  void _authenticateUserWithPhone() {
    PhoneVerificationFailed verificationFailed = (AuthException authException) {
      _bloc.changeAuthStatus(AuthStatus.phoneAuth);
      _showSnackBar(AuthConstants.verificationFailed);
      //TODO: show error to user.
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _bloc
          .signInWithCredential(phoneAuthCredential)
          .then((result) => _bloc.changeAuthStatus(AuthStatus.completed));
      print('Received phone auth credential: $phoneAuthCredential');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _bloc.changeVerificationId(verificationId);
      print(
          'Please check your phone for the verification code. $verificationId');
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("auto retrieval timeout");
    };

    _bloc.changeAuthStatus(AuthStatus.smsSent);
    _bloc.verifyPhoneNumber(codeAutoRetrievalTimeout, codeSent,
        verificationCompleted, verificationFailed);
  }

  _showSnackBar(String error) {
    final snackBar = SnackBar(content: Text(error));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _authCompleted(String nextRoute) async {
    final currUser = await _bloc.getCurrentUser();
    await _bloc.changeUid(currUser.uid);
    await _bloc.storeUid();
    await _bloc.changeIsAnonymous(currUser.isAnonymous);
    await _bloc.storeIsAnonymous();
    await _createNewUser(currUser);
    await _bloc.changeAuthStatus(AuthStatus.completed);
    await Navigator.pushNamed(context, nextRoute);
  }

  _createNewUser(FirebaseUser currUser) async {
    final userData = await _userBloc.userById(currUser.uid);

    if (userData.data == null) {
      _userBloc.create(new User(
          id: currUser.uid,
          isAnonymous: currUser.isAnonymous,
          creator: GlobalConstants.appName,
          email: _bloc.getEmail,
          phone: _bloc.getPhone,
          role: UserRole.User,
          name: "Test-${currUser.uid.substring(0, 3)}",
          avatar: "https://arber.redb.ai/favicon.ico"));
    } else {
      User user = User.fromJson(userData.data);
      _userBloc.update(User(
          id: user.id,
          isAnonymous: currUser.isAnonymous,
          creator: user.creator,
          email: user.email,
          phone: user.phone,
          role: (!currUser.isAnonymous && user.role == UserRole.Contact)
              ? UserRole.User
              : user.role,
          trustedContacts: user.trustedContacts,
          metadata: user.metadata));
    }
  }
}
