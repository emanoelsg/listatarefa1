// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

// App imports
import 'package:listatarefa1/firebase_options.dart';
import 'package:listatarefa1/app/features/auth/data/auth_repository_impl.dart';
import 'package:listatarefa1/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:listatarefa1/app/features/notifications/controller/notification_controller.dart';
import 'package:listatarefa1/app/features/notifications/service/notifications_service.dart';
import 'package:listatarefa1/app/features/tasks/data/task_repository_impl.dart';
import 'package:listatarefa1/app/features/tasks/presentation/controller/task_controller.dart';
import 'package:listatarefa1/app/utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();

  // Serviços e repositórios
  final taskRepository = TaskRepositoryImpl();
  final authRepository = AuthRepositoryImpl();
  final notificationService = NotificationService();
  await notificationService.init();

  // Controllers (injeção centralizada)
  Get.put(TaskController(repository: taskRepository));
  Get.put(AuthController(repository: authRepository));
  Get.put(NotificationController(service: notificationService));

  runApp(const ListTarefa());
}

class ListTarefa extends StatelessWidget {
  const ListTarefa({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
