import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/screens/profile/widgets/about/about_edit.dart';
import 'package:vouched/src/screens/profile/widgets/about/about_page.dart';
import 'package:vouched/src/screens/profile/widgets/job_history/job_history_edit.dart';
import 'package:vouched/src/screens/profile/widgets/job_history/job_history_page.dart';
import 'package:vouched/src/screens/profile/widgets/skills/skill_edit.dart';
import 'package:vouched/src/screens/profile/widgets/skills/skills_page.dart';

const AvatarStarColor = 0xff57aff5;

const AboutIndex = 0;
const JobHistoryIndex = 1;
const SkillsIndex = 2;

const ProfileIndex = 0;
const ProfilePosts = 1;

class Profile extends StatefulWidget {
  final String userId;

  Profile({
    @required this.userId,
  });

  @override
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> with TickerProviderStateMixin {
  UserBloc _userBloc;
  int _secondaryIndex = AboutIndex;
  int _primaryIndex = ProfileIndex;
  User _user;
  bool _allowUserEdit = false;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_userBloc == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var user;

    if (widget.userId == null) {
      _allowUserEdit = true;
      user = _userBloc.getCurrentUser();
    } else {
      user = _userBloc.getCurrentUserById(widget.userId);
    }

    return FutureBuilder(
      future: user,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        _user = snapshot.data;

        return Scaffold(
          floatingActionButton: _allowUserEdit
              ? [
                  JobHistoryIndex,
                  SkillsIndex,
                ].contains(_secondaryIndex)
                  ? _buildFloatingActionButton()
                  : Container()
              : Container(),
          appBar: AppBar(
            titleSpacing: 12,
            automaticallyImplyLeading: false,
            title: _buildTopMenu(),
            actions: _buildBackNavMenu(),
          ),
          body: _buildMainProfileFrame(),
        );
      },
    );
  }

  _buildFloatingActionButton() {
    if (!_allowUserEdit) return Container();

    return FloatingActionButton(
      onPressed: () {
        switch (_secondaryIndex) {
          case JobHistoryIndex:
            _addJobHistory();
            break;
          case SkillsIndex:
            _addSkill();
            break;
          default:
        }
      },
      child: Icon(
        Icons.add,
      ),
    );
  }

  _buildTopMenu() {
    final leadingAvatar = _buildLeadingAvatar();

    final topText = GestureDetector(
      onTap: () {
        if (_allowUserEdit) {
          _editName();
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(_user.name ?? ''),
            ),
            _allowUserEdit
                ? Container(
                    child: Text(
                      "Tap to update",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        leadingAvatar,
        topText,
      ],
    );
  }

  _buildBackNavMenu() {
    return <Widget>[
      IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.arrow_forward_ios,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  _buildLeadingAvatar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 3, left: 3, right: 0),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/isaac.jpg"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildPostsProfile() {
    return Center(
      child: Text(
        'Posts For ' + _user.name,
      ),
    );
  }

  _buildMainProfileFrame() {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (_primaryIndex == 0) _buildDotIndicator(),
              Container(),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Icon(_primaryIndex == ProfileIndex
                    ? Icons.arrow_upward
                    : Icons.arrow_downward),
              )
            ],
          ),
        ),
        PageView(
          onPageChanged: (index) {
            setState(() {
              _primaryIndex = index;
            });
          },
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _buildSecondaryProfileFrame(),
            _buildPostsProfile(),
          ],
        ),
      ],
    );
  }

  _buildDotIndicator() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 3.0,
            ),
            decoration: BoxDecoration(
              color: _secondaryIndex == 0 ? Colors.grey : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 8,
            height: 8,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 3.0,
            ),
            decoration: BoxDecoration(
              color: _secondaryIndex == 1 ? Colors.grey : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 8,
            height: 8,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 3.0,
            ),
            decoration: BoxDecoration(
              color: _secondaryIndex == 2 ? Colors.grey : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 8,
            height: 8,
          ),
        ],
      ),
    );
  }

  _buildSecondaryProfileFrame() {
    return PageView(
      onPageChanged: (index) {
        setState(() => _secondaryIndex = index);
      },
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        AboutPage(
          userBloc: _userBloc,
          user: _user,
          allowUserEdit: _allowUserEdit,
        ),
        JobHistoryPage(
          userBloc: _userBloc,
          user: _user,
          allowUserEdit: _allowUserEdit,
        ),
        SkillsPage(
          userBloc: _userBloc,
          user: _user,
          allowUserEdit: _allowUserEdit,
        ),
      ],
    );
  }

  _editName() {
    return Navigator.of(context).push(
      PageRouterEdit(
        userBloc: _userBloc,
        placeholder: 'Place add your name here',
        title: "Edit Name",
        user: _user,
        fieldToEdit: 'name',
        info:
            "You can add your complete name. Anyone who see your profile will the name",
        warning: "Are you sure you want to exit without save?",
      ),
    );
  }

  _addJobHistory() {
    return Navigator.of(context).push(
      PageRouterJobHistory(
        jobHistoryUID: '',
        userBloc: _userBloc,
        user: _user,
        title: "Add Job",
        jobTitle: "",
        jobWhereTitle: "",
        jobStart: null,
        jobEnd: null,
        info: "You can add information about your past or current job.",
        warning: "Are you sure you want to exit without save?",
        editing: false,
      ),
    );
  }

  _addSkill() {
    return Navigator.of(context).push(
      PageRouterSkill(
        skillUID: '',
        userBloc: _userBloc,
        user: _user,
        title: "Add Skill",
        name: '',
        value: 0.0,
        info:
            "You can add information about a skill that you consider important for your profile",
        warning: "Are you sure you want to exit without save?",
        editing: false,
      ),
    );
  }
}
