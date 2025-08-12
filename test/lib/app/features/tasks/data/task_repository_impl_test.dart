// test/lib/app/features/tasks/data/task_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:listatarefa1/app/features/tasks/data/task_repository_impl.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late TaskRepositoryImpl repository;

  const userId = 'user123';

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = TaskRepositoryImpl(firestore: firestore);
  });

  test('addTask e getTasks funcionam corretamente', () async {
    final task = TaskEntity(
      id: '',
      title: 'Test Task',
      isDone: false,
      userId: userId,
      createdAt: DateTime.now(),
    );

    await repository.addTask(userId, task);
    final tasks = await repository.getTasks(userId);

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Test Task');
    expect(tasks.first.isDone, false);
    expect(tasks.first.userId, userId);
  });

  test('updateTask atualiza os dados corretamente', () async {
    final taskRef = await firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add({
      'title': 'Old Title',
      'isDone': false,
      'createdAt': DateTime.now().toIso8601String(),
    });

    final updatedTask = TaskEntity(
      id: taskRef.id,
      title: 'Updated Title',
      isDone: true,
      userId: userId,
      createdAt: DateTime.now(),
    );

    await repository.updateTask(userId, updatedTask);

    final doc = await taskRef.get();
    expect(doc['title'], 'Updated Title');
    expect(doc['isDone'], true);
  });

  test('deleteTask remove a tarefa corretamente', () async {
    final taskRef = await firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add({
      'title': 'Task to delete',
      'isDone': false,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await repository.deleteTask(userId, taskRef.id);

    final doc = await taskRef.get();
    expect(doc.exists, false);
  });
}
