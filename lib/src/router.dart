import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/blocs/post.dart';
import 'package:vouched/src/blocs/tracking.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/blocs/waitlist.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/screens/auth/auth.dart';
import 'package:vouched/src/screens/dashboard/dashboard.dart';
import 'package:vouched/src/screens/posts/new-post.dart';
import 'package:vouched/src/screens/posts/view_post.dart';
import 'package:vouched/src/screens/profile/profile.dart';
import 'package:vouched/src/screens/settings/settings.dart';
import 'package:vouched/src/screens/trusted_share/trusted_share.dart';
import 'package:vouched/src/screens/waitlist/waitlist.dart';
import 'package:vouched/src/screens/waitlist_dashboard/waitlist_dashboard.dart';

class AuthRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaitListBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => WaitListBloc(),
        child: BlocProvider<UserBloc>(
            creator: (BuildContext context, BlocCreatorBag bag) => UserBloc(),
            child: StreamBuilder(builder: (context, snapshot) {
              return Scaffold(body: AuthScreen());
            })));
  }
}

class DashboardRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return StreamBuilder(
        stream: authBloc.authStatus,
        builder: (context, snapshot) {
          if (snapshot.data == AuthStatus.completed) {
            final dashboard = Dashboard();

            final dashboardWithUserBLoc = BlocProvider<UserBloc>(
                creator: (BuildContext context, BlocCreatorBag bag) =>
                    UserBloc(),
                child: dashboard);

            final dashboardWithTrackingBloc = BlocProvider<TrackingBloc>(
                creator: (BuildContext context, BlocCreatorBag bag) =>
                    TrackingBloc(),
                child: dashboardWithUserBLoc);

            final dashboardWithPostBloc = BlocProvider<PostBloc>(
                creator: (BuildContext context, BlocCreatorBag bag) =>
                    PostBloc(),
                child: dashboardWithTrackingBloc);

            return Scaffold(body: dashboardWithPostBloc);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class WaitListRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => UserBloc(),
        child: StreamBuilder(builder: (context, snapshot) {
          return WaitList();
        }));
  }
}

class WaitListDashboardRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaitListBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => WaitListBloc(),
        child: StreamBuilder(builder: (context, snapshot) {
          return WaitListDashboard();
        }));
  }
}

class TrustedShareRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context).settings.arguments;

    final trustedShareWithUserBLoc = BlocProvider<UserBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => UserBloc(),
        child: TrustedShare(post: post));

    final trustedShareWithPostBlock = BlocProvider<PostBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => PostBloc(),
        child: trustedShareWithUserBLoc);

    final trustedShareWithTrackingBloc = BlocProvider<TrackingBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => TrackingBloc(),
        child: trustedShareWithPostBlock);

    return trustedShareWithTrackingBloc;
  }
}

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final archiveWithPostBlock = BlocProvider<PostBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => PostBloc(),
        child: Settings());

    return archiveWithPostBlock;
  }
}

class PostRoute extends StatelessWidget {
  const PostRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context).settings.arguments;

    return ViewPost(
      post: post,
    );
  }
}

class NewPostRoute extends StatelessWidget {
  const NewPostRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newPostWithPostBloc = BlocProvider<PostBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => PostBloc(),
        child: NewPost());

    final newPostWithUserBLoc = BlocProvider<UserBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => UserBloc(),
        child: newPostWithPostBloc);

    return newPostWithUserBLoc;
  }
}

class ProfileRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileId = ModalRoute.of(context).settings.arguments;

    final profileWithUserBloc = BlocProvider<UserBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => UserBloc(),
        child: Profile(userId: profileId));

    final profileWithPostBloc = BlocProvider<PostBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => PostBloc(),
        child: profileWithUserBloc);

    final profileWithTracking = BlocProvider<TrackingBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) => TrackingBloc(),
        child: profileWithPostBloc);

    return profileWithTracking;
  }
}
