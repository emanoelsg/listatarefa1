// app/features/tasks/presentation/tasks_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_controller.dart';
import '../../../utils/constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    userId = Get.find<String>(tag: 'userId');
    controller.loadTasks(userId);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
//TODO: Implementar a tela de adicionar tarefas
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
          return const Center(child: CircularProgressIndicator(color: TColors.primary));
        }

        if (controller.tasks.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma tarefa encontrada',
              style: TextStyle(
                fontSize: 16,
                color: TColors.textSecondary,
              ),
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
                color: TColors.lightContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: TColors.borderPrimary),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
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
                      color: TColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: TColors.iconPrimary),
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