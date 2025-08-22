// app/features/tasks/presentation/controller/task_controller.dart
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/notifications/controller/notification_controller.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_repository.dart';
import 'package:uuid/uuid.dart';

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

  /// Load all tasks for a specific user
  Future<void> loadTasks(String userId) async {
    try {
      isLoading.value = true;
      tasks.value = await _repository.getTasks(userId);
    } catch (e) {
      message.value = 'Error loading tasks: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a new task
  Future<void> addTask(
    String userId,
    String title,
    String description, {
    String? repeatType,
    List<int>? weekDays,
    String? reminderTime,
  }) async {
    final task = TaskEntity(
      id: const Uuid().v4(),
      title: title,
      description: description,
      userId: userId,
      createdAt: DateTime.now(),
      repeatType: repeatType,
      weekDays: repeatType == 'weekly' ? weekDays : null,
      reminderTime: reminderTime,
    );

    try {
      await _repository.addTask(userId, task);

      // Schedule notifications
      if (task.reminderTime != null) {
        await _notificationController.scheduleReminderForTask(task);
      }

      await loadTasks(userId);
      message.value = 'Task added successfully';
    } catch (e) {
      message.value = 'Error adding task: $e';
    }
  }

  /// Update an existing task
  Future<void> updateTask(
    String userId,
    TaskEntity task, {
    String? repeatType,
    List<int>? weekDays,
    String? reminderTime,
  }) async {
    final updatedTask = task.copyWith(
      repeatType: repeatType,
      weekDays: repeatType == 'weekly' ? weekDays : null,
      reminderTime: reminderTime,
    );

    try {
      await _repository.updateTask(userId, updatedTask);

      // Update local list
      final index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }

      // Cancel previous notifications and schedule new ones
      await _notificationController.cancelRemindersForTask(task);
      if (updatedTask.reminderTime != null) {
        await _notificationController.scheduleReminderForTask(updatedTask);
      }

      message.value = 'Task updated';
    } catch (e) {
      message.value = 'Error updating task: $e';
    }
  }

  /// Delete a task
  Future<void> deleteTask(String userId, String taskId) async {
    try {
      final task = tasks.firstWhere((t) => t.id == taskId);

      await _repository.deleteTask(userId, taskId);
      tasks.removeWhere((t) => t.id == taskId);

      // Cancel all notifications for this task
      await _notificationController.cancelRemindersForTask(task);

      message.value = 'Task deleted';
    } catch (e) {
      message.value = 'Error deleting task: $e';
    }
  }

  /// Toggle task completion
  Future<void> toggleTaskDone(
      String userId, TaskEntity task, bool isDone) async {
    final updatedTask = task.copyWith(isDone: isDone);
    await updateTask(userId, updatedTask);
  }
}
