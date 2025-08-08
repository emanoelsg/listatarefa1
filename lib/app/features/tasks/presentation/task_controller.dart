// app/features/tasks/presentation/task_controller.dart
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';


class TaskController extends GetxController {
  var tasks = <TaskEntity>[].obs;
 

   void addTask(String title) {
    final task = TaskEntity(
      id: DateTime.now().toString(),
      title: title,
    );
    tasks.add(task);
  }

  void updateTask(TaskEntity task) {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      tasks[index] = task;
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }
}