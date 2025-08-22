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

  // Recorrência (novos)
  final String? repeatType; // "daily", "weekly" ou null/"none"
  final List<int>? weekDays; // 1=Seg ... 7=Dom (mesmo de DateTime.weekday)
  final String? reminderTime; // "HH:mm"

  TaskEntity({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    this.isDone = false,
    this.description,
    this.reminderAt,
    this.repeatType,
    this.weekDays,
    this.reminderTime,
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
      repeatType: map['repeatType'] as String?,
      weekDays:
          map['weekDays'] != null ? List<int>.from(map['weekDays']) : null,
      reminderTime: map['reminderTime'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'userId': userId,
      'createdAt': createdAt, // Firestore aceita DateTime -> Timestamp
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (reminderAt != null) 'reminderAt': reminderAt,
      if (repeatType != null) 'repeatType': repeatType,
      if (weekDays != null) 'weekDays': weekDays,
      if (reminderTime != null) 'reminderTime': reminderTime,
    };
  }

  TaskEntity copyWith({
    String? id,
    String? title,
    bool? isDone,
    String? userId,
    DateTime? createdAt,
    String? description,
    DateTime? reminderAt,
    String? repeatType,
    List<int>? weekDays,
    String? reminderTime,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      reminderAt: reminderAt ?? this.reminderAt,
      repeatType: repeatType ?? this.repeatType,
      weekDays: weekDays ?? this.weekDays,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
