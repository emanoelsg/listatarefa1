// app/features/tasks/domain/task_repository.dart
import 'task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks(String userId);
  Future<void> addTask(String userId, TaskEntity task);
  Future<void> updateTask(String userId, TaskEntity task);
  Future<void> deleteTask(String userId, String taskId);
}