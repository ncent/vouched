import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/blocs/tracking.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/constants/global.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/models/tracking.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/routes.dart';
import 'package:vouched/src/screens/trusted_share/mixins/phone_contacts.dart';
import 'package:vouched/src/screens/trusted_share/widgets/all_tile.dart';
import 'package:vouched/src/screens/trusted_share/widgets/contact_tile.dart';
import 'package:vouched/src/screens/trusted_share/widgets/search_bar.dart';
import 'package:vouched/src/screens/trusted_share/widgets/suggested_tile.dart';

const double TileSize = 75;

class TrustedShare extends StatefulWidget {
  final Post post;

  TrustedShare({
    @required this.post,
  });

  @override
  TrustedShareState createState() {
    return TrustedShareState();
  }
}

class TrustedShareState extends State<TrustedShare> with PhoneContacts {
  User _user;
  UserBloc _userBloc;
  AuthBloc _authBloc;
  TrackingBloc _trackingBloc;
  List<TrustedContact> _contactsFromPhone = List<TrustedContact>();
  List<TrustedContact> _trustedContacts = List<TrustedContact>();
  List<TrustedContact> _sentContacts = List<TrustedContact>();
  String _textToSearch = '';
  bool _isSuggestedSent = false;
  bool _isAllSent = false;
  bool _showAllContacts = true;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _trackingBloc = BlocProvider.of<TrackingBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    checkContactsPermission();
  }

  @override
  void dispose() {
    super.dispose();
    _userBloc.dispose();
    _contactsFromPhone.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _buildAppBar(),
      body: _buildContactsFromPhone(),
    );
  }

  _buildAppBar() {
    return AppBar(
      leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (_sentContacts.isNotEmpty && _authBloc.getIsAnonymous) {
              await _buildWarnAnonDialog();
            } else {
              Navigator.of(context).pushNamed(Routes.DashboardPath);
            }
          }),
      title: Text("Share This Post"),
    );
  }

  _buildWarnAnonDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 18.0, left: 15.0),
                      margin: EdgeInsets.only(top: 13.0, right: 8.0, left: 8.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ]),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "You can earn on average 10 points by logging in, log in now!",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(Routes.DashboardPath);
                                  }),
                              IconButton(
                                  icon: Icon(Icons.check_circle_outline),
                                  color: Colors.green,
                                  onPressed: () {
                                    _authBloc
                                        .changeAuthStatus(AuthStatus.phoneAuth);
                                    _authBloc.signOut();
                                    Navigator.of(context)
                                        .pushNamed(Routes.AuthRoutePath);
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
            /*actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                IconButton(
                    icon: Icon(Icons.check_circle_outline),
                    onPressed: () {
                      _authBloc.changeAuthStatus(AuthStatus.phoneAuth);
                      _authBloc.signOut();
                      Navigator.of(context).pushNamed(Routes.AuthRoutePath);
                    }),
              ],*/
            );
      },
    );
  }

  _buildContactsFromPhone() {
    if (_user == null) {
      _userBloc.getCurrentUser().then((currUser) {
        setState(() {
          _user = currUser;
          _trustedContacts = currUser.trustedContacts;
        });
      });

      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: <Widget>[
        SearchBar(
          onTextSearch: _onTextSearch,
        ),
        Divider(
          height: 0,
          thickness: 0.2,
          color: Colors.grey,
        ),
        SuggestedTile(
          isSuggestedSent: _isSuggestedSent,
          onDismissSuggestedFilter: _sendSuggestedFilter,
          onTapSuggestedFilter: _applySuggestedFilter,
        ),
        Divider(
          height: 0,
          thickness: 0.2,
          color: Colors.grey,
        ),
        AllTile(
          isAllSent: _isAllSent,
          onDismissAllFilter: _sendAllFilter,
          onTapAllFilter: _applyAllFilter,
        ),
        Divider(
          height: 0,
          thickness: 0.2,
          color: Colors.grey,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 16,
              bottom: 10,
            ),
            child:
                Text(_showAllContacts ? "ALL CONTACTS" : "SUGGESTED CONTACTS",
                    style: TextStyle(
                      letterSpacing: 0.2,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    )),
          ),
        ),
        Expanded(
          child: _buildContactsList(),
        ),
      ],
    );
  }

  _buildContactsList() {
    return FutureBuilder(
      future: getContactsAsStream(),
      builder: (context, AsyncSnapshot<Iterable<Contact>> streamData) {
        if (streamData.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (isPermissionDenied) {
          return _requestSettingsChange();
        }

        final contactsFromPhone = streamData.data.map((contact) {
          // Convert into TrustedContact
          return TrustedContact.fromMap(contact.toMap());
        }).toList();

        _contactsFromPhone = contactsFromPhone.where((contact) {
          return !_trustedContacts
              .map((c) => c.identifier)
              .toList()
              .contains(contact.identifier);
        }).toList();

        final List<TrustedContact> allContacts = [
          ..._trustedContacts,
          if (_showAllContacts) ...contactsFromPhone
        ].toSet().where((contact) {
          if (_textToSearch == null || _textToSearch.isEmpty) {
            return true;
          }

          return contact.displayName
              .toLowerCase()
              .contains(_textToSearch.toLowerCase());
        }).toList();

        final List<String> strList = [];
        strList.clear();

        for (final contact in allContacts) {
          strList.add(contact.displayName.toString());
        }

        return AlphabetListScrollView(
          normalTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          strList: strList,
          showPreview: false,
          highlightTextStyle: TextStyle(
            color: Colors.blueAccent,
          ),
          keyboardUsage: false,
          itemBuilder: (context, index) {
            final TrustedContact contact = allContacts[index];

            return Column(
              children: <Widget>[
                ContactTile(
                  isSuggested: contact.isSuggested,
                  enabled: !_sentContacts.contains(contact),
                  contact: contact,
                  onSendInvitationToSingleContact:
                      _sendInvitationToSingleContact,
                  onRemoveFromTrustedContacts: _removeFromTrustedContact,
                ),
                if (index != strList.length - 1)
                  Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                    height: 0,
                  )
              ],
            );
          },
          indexedHeight: (int) {
            return TileSize;
          },
        );
      },
    );
  }

  _onTextSearch(String text) {
    setState(() {
      _textToSearch = text;
    });
  }

  _removeFromTrustedContact(TrustedContact contact) async {
    setState(() {
      contact.isSuggested = false;
      _trustedContacts.remove(contact);
    });
    await _userBloc.updateTrustedContacts(_user.id, _trustedContacts);
  }

  _sendInvitationToSingleContact(TrustedContact contact) async {
    setState(() {
      if (!_trustedContacts.contains(contact)) {
        contact.isSuggested = true;
        _trustedContacts.add(contact);
      }
      _sentContacts.add(contact);
    });
    await _userBloc.updateTrustedContacts(_user.id, _trustedContacts);
    _trackingBloc.track(Tracking(
        userID: _user.id,
        txAction: TrackingAction.SinglePostShared,
        metadata: {
          "postID": widget.post.id,
          "Contact": contact.toMap(),
        }));
  }

  _requestSettingsChange() {
    return Center(
      child: RaisedButton(
        onPressed: () => requestPermissionOnSettings(),
        child: Text(
            'Failed to retrieve your contacts, please check your configurations for ${GlobalConstants.appName}'),
      ),
    );
  }

  _applySuggestedFilter() {
    setState(() {
      _showAllContacts = false;
    });
  }

  _applyAllFilter() {
    setState(() {
      _showAllContacts = true;
    });
  }

  _sendSuggestedFilter() async {
    setState(() {
      _isSuggestedSent = true;
      _sentContacts.addAll(_trustedContacts);
    });
    await _userBloc.updateTrustedContacts(
        _user.id,
        _sentContacts.map((TrustedContact contact) {
          contact.isSuggested = true;
          return contact;
        }).toList());
    _trackingBloc.track(Tracking(
      userID: _user.id,
      txAction: TrackingAction.SuggestedPostShared,
      metadata: {
        "postID": widget.post.id,
      },
    ));
  }

  _sendAllFilter() async {
    setState(() {
      _isSuggestedSent = true;
      _isAllSent = true;
      _sentContacts.addAll(
          [..._contactsFromPhone, ..._trustedContacts].toSet().toList());
    });
    await _userBloc.updateTrustedContacts(
        _user.id,
        _sentContacts.map((TrustedContact contact) {
          contact.isSuggested = true;
          return contact;
        }).toList());

    _trackingBloc.track(Tracking(
      userID: _user.id,
      txAction: TrackingAction.AllPostShared,
      metadata: {
        "postID": widget.post.id,
      },
    ));
  }
}
