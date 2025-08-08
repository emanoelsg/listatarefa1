// app/features/tasks/domain/task_entity.dart
class TaskEntity {
  final String id;
  final String title;
  final bool isDone;

  TaskEntity({
    required this.id,
    required this.title,
    this.isDone = false,
  });
}
