// app/features/tasks/domain/task_entity.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEntity {
  final String id;
  final String title;
  final bool isDone;
  final String userId;
  final DateTime createdAt;
  final String? description;
  final DateTime? reminderAt;

  TaskEntity({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    this.isDone = false,
    this.description,
    this.reminderAt,
  });

  factory TaskEntity.fromMap(Map<String, dynamic> map, String docId) {
    return TaskEntity(
      id: docId,
      title: map['title'] as String,
      isDone: map['isDone'] as bool? ?? false,
      userId: map['userId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      description: map['description'] as String?,
      reminderAt: map['reminderAt'] != null
          ? (map['reminderAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'userId': userId,
      'createdAt': createdAt,
      if (description != null) 'description': description,
      if (reminderAt != null) 'reminderAt': reminderAt,
    };
  }

  TaskEntity copyWith({
    String? id,
    String? title,
    bool? isDone,
    String? userId,
    DateTime? createdAt,
    String? description,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
    );
  }
}
