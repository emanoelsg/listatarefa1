// main.dart

//Firebase
import 'package:firebase_core/firebase_core.dart';
//Flutter
import 'package:flutter/material.dart';
//GetX
import 'package:get/get.dart';
//App
import 'package:listatarefa1/app/features/auth/data/auth_repository_impl.dart';
import 'package:listatarefa1/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:listatarefa1/app/features/notifications/controller/notification_controller.dart';
import 'package:listatarefa1/app/features/notifications/service/notifications_service.dart';
import 'package:listatarefa1/app/features/tasks/data/task_repository_impl.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_repository.dart';
import 'package:listatarefa1/app/features/tasks/presentation/controller/task_controller.dart';
import 'package:listatarefa1/app/utils/theme/theme.dart';
import 'package:listatarefa1/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final taskRepository = TaskRepositoryImpl();

  Get.put<TaskRepository>(taskRepository);
  Get.put<TaskController>(TaskController(repository: taskRepository));
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final notificationService = NotificationService();
  await notificationService.init();
  Get.put<NotificationService>(notificationService);
  final notificationController =
      NotificationController(service: notificationService);
  Get.put<NotificationController>(notificationController);
  runApp(ListTarefa());
}

class ListTarefa extends StatelessWidget {
  const ListTarefa({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl();
    Get.put<AuthController>(AuthController(repository: authRepository));
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
