import 'package:flutter/material.dart';
import 'package:trash_hunt/features/auth/views/signin_screen.dart';
import 'package:trash_hunt/features/auth/views/signup_screen.dart';
import 'package:trash_hunt/features/main/create_hunter/views/create_hunter_screen.dart';
import 'package:trash_hunt/features/main/home/views/trash_detail_screen.dart';
import 'package:trash_hunt/features/main/main_screen.dart';
import 'package:trash_hunt/features/main/profile/views/edit_profile_screen.dart';
import 'package:trash_hunt/features/main/quests/views/quest_detail_screen.dart';

class AppRouter {
  static const String signin = "/signin";
  static const String signup = "/signup";
  static const String home = "/home";
  static const String quests = "/quests";
  static const String profile = "/profile";
  static const String editProfile = "/edit-profile";
  static const String trashDetail = "/trash-detail";
  static const String questDetail = "/quest-detail";
  static const String createHunter = "/create-hunter";

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
      case editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case trashDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TrashDetailScreen(
            type: args['type'],
            description: args['description'],
          ),
        );
      case questDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => QuestDetailScreen(
            questData: args['questData'],
          ),
        );
      case createHunter:
        return MaterialPageRoute(builder: (_) => CreateHunterScreen());
      default:
        return MaterialPageRoute(builder: (_) => SignInScreen());
    }
  }
}