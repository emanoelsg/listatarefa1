// test/lib/app/features/tasks/presentation/task_controller_test.dart
// test/lib/app/features/tasks/presentation/task_controller_test.dartart
import 'package:flutter_test/flutter_test.dart';
import 'package:listatarefa1/app/features/notifications/controller/notification_controller.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_repository.dart';
import 'package:listatarefa1/app/features/tasks/presentation/controller/task_controller.dart';
import 'package:mocktail/mocktail.dart';

// ---------------- Mocks ----------------
class MockTaskRepository extends Mock implements TaskRepository {}

class FakeTaskEntity extends Fake implements TaskEntity {}

class MockNotificationController extends Mock
    implements NotificationController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TaskController controller;
  late MockTaskRepository mockRepository;
  late MockNotificationController mockNotif;
  const userId = 'user123';

  setUpAll(() {
    registerFallbackValue(FakeTaskEntity());
  });

  setUp(() {
    mockRepository = MockTaskRepository();
    mockNotif = MockNotificationController();

    controller = TaskController(
      repository: mockRepository,
      notificationController: mockNotif,
    );
  });

  group('TaskController Tests', () {
    test(
        'addTask should call repository, schedule notification, and reload tasks',
        () async {
      TaskEntity? addedTask;

      // Mock repository addTask
      when(() => mockRepository.addTask(any(), any()))
          .thenAnswer((invocation) async {
        addedTask = invocation.positionalArguments[1] as TaskEntity;
      });

      // Mock repository getTasks
      when(() => mockRepository.getTasks(userId))
          .thenAnswer((_) async => addedTask != null ? [addedTask!] : []);

      // Mock notification
      when(() => mockNotif.scheduleReminderForTask(any()))
          .thenAnswer((_) async {});

      // Act
      await controller.addTask(userId, 'Test Task', '');

      // Assert
      verify(() => mockRepository.addTask(userId, any())).called(1);
      verifyNever(() => mockNotif.scheduleReminderForTask(any()));

      expect(controller.tasks.length, 1);
      expect(controller.tasks.first.title, 'Test Task');
    });

    test('loadTasks should fetch tasks and update state', () async {
      final sampleTask = TaskEntity(
        id: 'task1',
        title: 'Test Task',
        userId: userId,
        createdAt: DateTime(2023, 1, 1),
      );

      when(() => mockRepository.getTasks(userId))
          .thenAnswer((_) async => [sampleTask]);

      await controller.loadTasks(userId);

      expect(controller.tasks.length, 1);
      expect(controller.tasks.first.title, 'Test Task');
      expect(controller.isLoading.value, false);
    });
    test(
        'updateTask should modify task in the list, cancel and schedule notifications',
        () async {
      final sampleTask = TaskEntity(
        id: 'task1',
        title: 'Test Task',
        userId: userId,
        createdAt: DateTime(2023, 1, 1),
      );
      controller.tasks.value = [sampleTask];

      final updatedTask = TaskEntity(
        id: 'task1',
        title: 'Updated Task',
        userId: userId,
        createdAt: sampleTask.createdAt,
        reminderTime: "08:00",
      );

      when(() => mockRepository.updateTask(userId, any()))
          .thenAnswer((_) async {});
      when(() => mockNotif.cancelRemindersForTask(any()))
          .thenAnswer((_) async {});
      when(() => mockNotif.scheduleReminderForTask(any()))
          .thenAnswer((_) async {});

      await controller.updateTask(userId, updatedTask);

      verify(() => mockRepository.updateTask(userId, any())).called(1);
      verify(() => mockNotif.cancelRemindersForTask(any())).called(1);
      verify(() => mockNotif.scheduleReminderForTask(any())).called(1);

      expect(controller.tasks.first.title, 'Updated Task');
    });

    test('deleteTask should remove task from list and cancel all notifications',
        () async {
      final sampleTask = TaskEntity(
        id: 'task1',
        title: 'Test Task',
        userId: userId,
        createdAt: DateTime(2023, 1, 1),
      );
      controller.tasks.value = [sampleTask];

      when(() => mockRepository.deleteTask(userId, sampleTask.id))
          .thenAnswer((_) async {});
      when(() => mockNotif.cancelRemindersForTask(any()))
          .thenAnswer((_) async {});

      await controller.deleteTask(userId, sampleTask.id);

      expect(controller.tasks.isEmpty, true);
      verify(() => mockRepository.deleteTask(userId, sampleTask.id)).called(1);
      verify(() => mockNotif.cancelRemindersForTask(sampleTask)).called(1);
    });
  });
}
