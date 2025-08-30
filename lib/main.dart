import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/config/level_config.dart';
import 'package:trash_hunt/core/routing/app_router.dart';
import 'package:trash_hunt/core/services/session_manager.dart';
import 'package:trash_hunt/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:trash_hunt/features/auth/services/auth_repository_impl.dart';
import 'package:trash_hunt/features/main/create_hunter/viewmodels/create_hunter_viewmodel.dart';
import 'package:trash_hunt/features/main/home/viewmodels/home_viewmodel.dart';
import 'package:trash_hunt/features/main/profile/viewmodels/edit_profile_viewmodel.dart';
import 'package:trash_hunt/features/main/profile/viewmodels/profile_viewmodel.dart';
import 'package:trash_hunt/features/main/quests/viewmodels/quest_detail_viewmodel.dart';
import 'package:trash_hunt/features/main/quests/viewmodels/quest_viewmodel.dart';
import 'package:trash_hunt/features/main/services/hunter_repository_impl.dart';
import 'package:trash_hunt/features/main/services/quest_repository_impl.dart';
import 'package:trash_hunt/features/main/services/trash_repository_impl.dart';
import 'firebase_options.dart';

const apiKey = 'AIzaSyDkCVHZU5AQASQwAwrocMDLuU1lM8ILWBw';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await LevelConfig.load(); 
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Gemini.init(apiKey: apiKey);

  runApp(
    MultiProvider(
      providers: [
        Provider<SessionManager>(create: (_) => SessionManager()),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(TrashRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => QuestViewModel(QuestRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateHunterViewModel(HunterRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(HunterRepositoryImpl(), AuthRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => EditProfileViewModel(HunterRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => QuestDetailViewModel(QuestRepositoryImpl()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trash Hunt',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.signin,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

