// app/main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listatarefa1/app/features/auth/data/auth_repository_impl.dart';
import 'package:listatarefa1/app/features/auth/presentation/auth_controller.dart';
import 'package:listatarefa1/app/features/auth/presentation/login_page.dart';
import 'package:listatarefa1/app/features/tasks/data/task_repository_impl.dart';
import 'package:listatarefa1/app/features/tasks/presentation/task_controller.dart';
import 'package:listatarefa1/app/features/tasks/presentation/tasks_page.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/utils/theme/theme.dart';
import 'package:listatarefa1/firebase_options.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  Get.put(AuthController(repository: AuthRepositoryImpl()));
  Get.put(TaskController(repository: TaskRepositoryImpl()));

  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    Get.put<String>(user.uid, tag: 'userId');
  }

  runApp(const ListTarefa());
}

class ListTarefa extends StatefulWidget {
  const ListTarefa({super.key});

  @override
  State<ListTarefa> createState() => _ListTarefa();
}

class _ListTarefa extends State<ListTarefa> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: FirebaseAuth.instance.currentUser != null
            ? const HomePage()
            : const LoginPage(),
      ),
    );
  }
}
