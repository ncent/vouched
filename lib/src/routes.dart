import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/router.dart';

class Routes {
  static const AuthRoutePath = '/';
  static const DashboardPath = '/dashboard';
  static const PostPath = '/post';
  static const NewPostPath = '/new-post';
  static const WaitlistPath = '/waitlist';
  static const WaitlistDashboardPath = '/waitlist-dashboard';
  static const TrustedSharedPath = '/trusted-share';
  static const TrustedConnectionsPath = '/trusted-connections';
  static const ArchivePath = '/archive';
  static const SettingsPath = '/settings';
  static const ProfilePath = '/profile';

  static final appRoutes = <String, WidgetBuilder>{
    Routes.AuthRoutePath: (context) => AuthRoute(),
    Routes.DashboardPath: (context) => DashboardRoute(),
    Routes.PostPath: (context) => PostRoute(),
    Routes.NewPostPath: (context) => NewPostRoute(),
    Routes.WaitlistPath: (context) => WaitListRoute(),
    Routes.WaitlistDashboardPath: (context) => WaitListDashboardRoute(),
    Routes.TrustedSharedPath: (context) => TrustedShareRoute(),
    Routes.SettingsPath: (context) => SettingsRoute(),
    Routes.ProfilePath: (context) => ProfileRoute(),
  };

  static void routeForSignedInUser(BuildContext context, String routePath,
      Object _currPostOnScreen, AuthBloc authBloc) {
    if (authBloc.getIsAnonymous) {
      authBloc.changeAuthStatus(AuthStatus.phoneAuth);
      authBloc.signOut();
      Navigator.pushNamed(
        context,
        Routes.AuthRoutePath,
      );
    } else {
      Navigator.pushNamed(
        context,
        routePath,
        arguments: _currPostOnScreen,
      );
    }
  }

  static buildAppRoutes() {
    return appRoutes;
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
