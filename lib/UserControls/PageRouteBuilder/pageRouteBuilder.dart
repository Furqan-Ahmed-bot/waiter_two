import 'package:flutter/material.dart';
import 'package:ts_app_development/Authentication/Login/login.dart';
import 'package:ts_app_development/Screens/Dashboard/dashboard.dart';
import 'package:ts_app_development/Screens/MarkAttendance/markAttendance.dart';
import 'package:ts_app_development/Screens/genericScreen.dart';

class CustomPageRouteBuilder {
  static Route createRoute(routeName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          GenericScreen(route: routeName),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
