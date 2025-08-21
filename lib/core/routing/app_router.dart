import 'package:flutter/material.dart';
import 'package:trash_hunt/features/auth/views/signin_screen.dart';
import 'package:trash_hunt/features/auth/views/signup_screen.dart';
import 'package:trash_hunt/features/main/main_screen.dart';

class AppRouter {
  static const String signin = "/signin";
  static const String signup = "/signup";
  static const String home = "/home";
  static const String quests = "/quests";
  static const String profile = "/profile";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signin:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case home:
        return MaterialPageRoute(builder: (_) => MainScreen(initialIndex: 0));
      case quests:
        return MaterialPageRoute(builder: (_) => MainScreen(initialIndex: 1));
      case profile:
        return MaterialPageRoute(builder: (_) => MainScreen(initialIndex: 2));
      default:
        return MaterialPageRoute(builder: (_) => SignInScreen());
    }
  }
}