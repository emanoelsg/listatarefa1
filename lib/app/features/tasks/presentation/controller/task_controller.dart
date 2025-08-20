// app/features/tasks/presentation/controller/task_controller.dart
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../domain/task_entity.dart';
import '../../domain/task_repository.dart';
import '../../../notifications/controller/notification_controller.dart';

class TaskController extends GetxController {
  final TaskRepository _repository;
  final NotificationController _notificationController;

  TaskController({
    required TaskRepository repository,
    NotificationController? notificationController,
  })  : _repository = repository,
        _notificationController =
            notificationController ?? Get.find<NotificationController>();

  final tasks = <TaskEntity>[].obs;
  final isLoading = false.obs;
  final message = RxnString();

  Future<void> loadTasks(String userId) async {
    try {
      isLoading.value = true;
      tasks.value = await _repository.getTasks(userId);
    } catch (e) {
      message.value = 'Erro ao carregar tarefas $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(String userId, String title, String description) async {
    final task = TaskEntity(
      id: const Uuid().v4(),
      title: title,
      userId: userId,
      createdAt: DateTime.now(),
      description: description,
    );
    try {
      await _repository.addTask(userId, task);
      _notificationController.scheduleTaskReminder(task);
      await loadTasks(userId);
      message.value = 'Tarefa adicionada com sucesso';
    } catch (e) {
      message.value = 'Erro ao adicionar tarefa $e';
    }
  }

  Future<void> updateTask(String userId, TaskEntity task) async {
    try {
      await _repository.updateTask(userId, task);
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
      }
      _notificationController.scheduleTaskReminder(task);
      message.value = 'Tarefa atualizada';
    } catch (e) {
      message.value = 'Erro ao atualizar tarefa $e';
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _repository.deleteTask(userId, taskId);
      tasks.removeWhere((t) => t.id == taskId);

      // Cancela notificações associadas à tarefa
      final baseId = taskId.codeUnits.fold(0, (prev, el) => prev + el);

      _notificationController
          .cancelNotification(baseId); // notificação única/diária
      for (var wd = 1; wd <= 7; wd++) {
        _notificationController.cancelNotification(baseId + wd); // semanais
      }

      message.value = 'Tarefa excluída';
    } catch (e) {
      message.value = 'Erro ao excluir tarefa $e';
    }
  }
}
