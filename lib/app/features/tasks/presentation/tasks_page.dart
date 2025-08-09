// app/features/tasks/presentation/tasks_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_controller.dart';

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
      appBar: AppBar(
        title: const Text('Lista de Tarefa'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.addTask(userId, 'Nova tarefa');
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tasks.isEmpty) {
          return const Center(child: Text('Nenhuma tarefa encontrada'));
        }

        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (value) {
                    controller.updateTask(
                      userId,
                      task.copyWith(isDone: value ?? false),
                    );
                  },
                ),
                title: Text(task.title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    controller.deleteTask(userId, task.id);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
