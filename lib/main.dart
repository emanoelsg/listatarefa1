// main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listatarefa1/app/features/auth/data/auth_repository_impl.dart';
import 'package:listatarefa1/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:listatarefa1/app/features/auth/presentation/pages/login/login_page.dart';
import 'package:listatarefa1/app/features/tasks/data/task_repository_impl.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_repository.dart';
import 'package:listatarefa1/app/features/tasks/presentation/task_controller.dart';
import 'package:listatarefa1/app/features/tasks/presentation/tasks_page.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/utils/theme/theme.dart';
import 'package:listatarefa1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final taskRepository = TaskRepositoryImpl();
  final authRepository = AuthRepositoryImpl();

  Get.put<TaskRepository>(taskRepository);
  Get.put<TaskController>(TaskController(repository: taskRepository));
  Get.put<AuthController>(AuthController(repository: authRepository));

   final user = FirebaseAuth.instance.currentUser;
   Get.put<String>(user?.uid ?? 'user123', tag: 'userId');

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
