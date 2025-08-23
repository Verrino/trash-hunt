import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/routing/app_router.dart';
import 'package:trash_hunt/core/services/session_manager.dart';
import 'package:trash_hunt/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:trash_hunt/features/auth/services/auth_repository_impl.dart';
import 'package:trash_hunt/features/main/home/viewmodels/home_viewmodel.dart';
import 'package:trash_hunt/features/main/quests/viewmodels/quest_viewmodel.dart';
import 'package:trash_hunt/features/main/services/trash_repository_impl.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
          create: (_) => QuestViewModel(TrashRepositoryImpl()),
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

