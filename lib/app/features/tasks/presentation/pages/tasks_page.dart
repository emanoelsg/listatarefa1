// app/features/tasks/presentation/pages/tasks_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/tasks/presentation/controller/task_controller.dart';
import 'package:listatarefa1/app/features/tasks/presentation/pages/addtask_page.dart';
import 'package:listatarefa1/app/utils/constants/colors.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TaskController controller;
  late final String userId;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TaskController>();
    userId = widget.userId;
    controller.loadTasks(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddTaskPage(), arguments: userId);
        },
        backgroundColor: TColors.accent,
        child: const Icon(Icons.add, color: TColors.textWhite),
      ),
      body: Obx(() {
        final message = controller.message.value;
        if (message != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.snackbar(
              'Aviso',
              message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: TColors.error,
              colorText: TColors.textWhite,
              margin: const EdgeInsets.all(12),
              borderRadius: 8,
            );
            controller.message.value = null;
          });
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: TColors.primary),
          );
        }

        if (controller.tasks.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma tarefa encontrada',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  onLongPress: () {
                    Get.to(() => AddTaskPage(existingTask: task),
                        arguments: userId);
                  },
                  leading: Checkbox(
                    value: task.isDone,
                    activeColor: TColors.primary,
                    onChanged: (value) {
                      controller.updateTask(
                        userId,
                        task.copyWith(isDone: value ?? false),
                      );
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration:
                          task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: TColors.iconPrimary),
                    onPressed: () {
                      controller.deleteTask(userId, task.id);
                    },
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
