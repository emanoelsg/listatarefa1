// app/features/tasks/data/task_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/task_entity.dart';
import '../domain/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<TaskEntity>> getTasks(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();

    return snapshot.docs
        .map((doc) => TaskEntity.fromMap(doc.data(), doc.id)) 
        .toList();
  }

  @override
  Future<void> addTask(String userId, TaskEntity task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toMap());
  }

  @override
  Future<void> updateTask(String userId, TaskEntity task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap()); 
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}