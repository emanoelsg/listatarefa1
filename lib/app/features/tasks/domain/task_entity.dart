// app/features/tasks/domain/task_entity.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEntity {
  final String id;
  final String title;
  final bool isDone;
  final String userId;
  final DateTime createdAt;
  final String? description;

  TaskEntity({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    this.isDone = false,
    this.description,
  });

  factory TaskEntity.fromMap(Map<String, dynamic> map, String docId) {
    return TaskEntity(
      id: docId,
      title: map['title'] as String,
      isDone: map['isDone'] as bool? ?? false,
      userId: map['userId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'userId': userId,
      'createdAt': createdAt,
      if (description != null) 'description': description,
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
