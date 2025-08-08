// app/main.dart
import 'package:flutter/material.dart';
import 'package:listatarefa1/app/features/auth/presentation/auth_controller.dart';
import 'package:listatarefa1/app/features/tasks/presentation/task_controller.dart';
import 'package:listatarefa1/app/features/tasks/presentation/tasks_page.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/utils/theme/theme.dart';

void main() {
  Get.put(AuthController());
  Get.put(TaskController());
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
        home: const HomePage(),
      ),
    );
  }
}
