import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/blocs/post.dart';
import 'package:vouched/src/blocs/tracking.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/routes.dart';
import 'package:vouched/src/screens/dashboard/post/posts_viewer.dart';
import 'package:vouched/src/screens/profile/profile.dart';
import 'package:vouched/src/screens/widgets/vdrawer.dart';
import 'package:vouched/src/screens/widgets/vicons.dart';

const DeltaMagNeeded = 50;

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  AuthBloc _authBloc;
  PostBloc _postBloc;
  UserBloc _userBloc;
  TrackingBloc _trackingBlock;
  Post _currPostOnScreen;
  VDrawer _vDrawer;

  DashboardState();

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _trackingBlock = BlocProvider.of<TrackingBloc>(context);
    _vDrawer = VDrawer(user: _userBloc.getCurrentUser());
    _currPostOnScreen = null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //return a `Future` with false value so this route cant be popped or closed.
        return Future.value(false);
      },
      child: GestureDetector(
          onPanUpdate: (details) {
            if (_currPostOnScreen == null) {
              return;
            }

            if (details.delta.dx > DeltaMagNeeded) {
              _onShowProfile();
            }

            if (details.delta.dx < -DeltaMagNeeded) {
              Navigator.pushNamed(
                context,
                Routes.TrustedSharedPath,
                arguments: _currPostOnScreen,
              );
            }
          },
          child: Scaffold(
            drawer: _vDrawer,
            floatingActionButton: _buildFAB(),
            body: StreamBuilder(
                stream: _postBloc.listPosts(
                  _authBloc.getUid,
                  isAnon: _authBloc.getIsAnonymous,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      (snapshot.hasData &&
                          snapshot.data.documents.length == 0)) {
                    return Center(
                      child: Text("No Posts"),
                    );
                  }

                  List<Post> posts = _postBloc.mapToList(snapshot.data);

                  if (_currPostOnScreen == null) {
                    Future.delayed(const Duration(milliseconds: 10), () {
                      setState(() {
                        _currPostOnScreen = posts.first;
                      });
                    });
                  }

                  return Stack(
                    children: <Widget>[
                      PostsViewer(
                        posts: posts,
                        onPostSwipedCompleted: _onPostSwipedCompleted,
                        onPostTapped: _onPostTapped,
                        onShowProfile: _onShowProfile,
                        trackingBloc: _trackingBlock,
                        authBloc: _authBloc,
                      ),
                      !_authBloc.getIsAnonymous
                          ? Positioned(
                              top: 42,
                              left: 20,
                              child: IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            )
                          : Container(),
                    ],
                  );
                }),
          )),
    );
  }

  _onShowProfile() {
    final profileWithUserBloc = BlocProvider<UserBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => UserBloc(),
        child: Profile(
          userId: _currPostOnScreen.creator,
        ));

    final profileWithTrackingBloc = BlocProvider<TrackingBloc>(
      creator: (BuildContext context, BlocCreatorBag bag) => TrackingBloc(),
      child: profileWithUserBloc,
    );

    Navigator.push(
        context,
        SlideRightRoute(
          page: profileWithTrackingBloc,
        ));
  }

  _onPostSwipedCompleted(Post post) {
    _currPostOnScreen = post;
  }

  _onPostTapped(Post post) {
    /*Navigator.pushNamed(
      context,
      Routes.PostPath,
      arguments: post,
    );*/
  }

  _buildFAB() {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              if (_currPostOnScreen != null)
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        VIcons.share,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.TrustedSharedPath,
                          arguments: _currPostOnScreen,
                        );
                      },
                    ),
                    Text(
                      'Share',
                      style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              color: Colors.blueGrey,
                              offset: Offset(2, 2),
                            ),
                          ],
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    )
                  ],
                ),
            ],
          )
        ],
      ),
    ));
  }
}
