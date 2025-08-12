// test/lib/app/features/tasks/domain/task_entity_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';

void main() {
  group('TaskEntity', () {
    test('toMap deve converter corretamente para Map', () {
      final task = TaskEntity(
        id: '1',
        title: 'Test',
        isDone: true,
        userId: 'user123',
        createdAt: DateTime(2023, 1, 1),
      );

      final map = task.toMap();

      expect(map['title'], 'Test');
      expect(map['isDone'], true);
      expect(map['userId'], 'user123');
      expect(map['createdAt'], DateTime(2023, 1, 1));
    });

    test('fromMap deve criar TaskEntity corretamente', () {
      final timestamp = Timestamp.fromDate(DateTime(2023, 1, 1));
      final map = {
        'title': 'Test',
        'isDone': false,
        'userId': 'user123',
        'createdAt': timestamp,
      };

      final task = TaskEntity.fromMap(map, 'abc');

      expect(task.id, 'abc');
      expect(task.title, 'Test');
      expect(task.isDone, false);
      expect(task.userId, 'user123');
      expect(task.createdAt, DateTime(2023, 1, 1));
    });

    test('copyWith deve retornar nova instância com campos modificados', () {
      final original = TaskEntity(
        id: '1',
        title: 'Original',
        isDone: false,
        userId: 'user123',
        createdAt: DateTime(2023, 1, 1),
      );

      final updated = original.copyWith(title: 'Updated', isDone: true);

      expect(updated.id, '1');
      expect(updated.title, 'Updated');
      expect(updated.isDone, true);
      expect(updated.userId, 'user123');
      expect(updated.createdAt, DateTime(2023, 1, 1));
    });
  });
}
