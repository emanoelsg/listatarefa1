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



  runApp( ListTarefa());
}

class ListTarefa extends StatelessWidget {
  const ListTarefa({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
           if (snapshot.hasData) {
              return const HomePage();
            }
            return const LoginPage();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
