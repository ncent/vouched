import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/constants/constants.dart';
import 'package:vouched/src/constants/global.dart';
import 'package:vouched/src/routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      creator: (BuildContext context, BlocCreatorBag bag) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: GlobalConstants.appName,
        theme: Constants.lightTheme,
        darkTheme: Constants.darkTheme,
        initialRoute: '/',
        routes: Routes.buildAppRoutes(),
      ),
    );
  }
}
