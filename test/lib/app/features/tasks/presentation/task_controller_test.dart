// test/lib/app/features/tasks/presentation/task_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:listatarefa1/app/features/notifications/controller/notification_controller.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_repository.dart';
import 'package:listatarefa1/app/features/tasks/presentation/controller/task_controller.dart';
import 'package:mocktail/mocktail.dart';

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

    // Inject mocked repository and notification controller
    controller = TaskController(
      repository: mockRepository,
      notificationController: mockNotif,
    );
  });

  test(
      'addTask should call repository, schedule notification, and reload tasks',
      () async {
    TaskEntity? addedTask;

    // Capture the task added to repository
    when(() => mockRepository.addTask(any(), any()))
        .thenAnswer((invocation) async {
      addedTask = invocation.positionalArguments[1] as TaskEntity;
    });

    // Return the added task when loadTasks is called
    when(() => mockRepository.getTasks(userId)).thenAnswer((_) async {
      return addedTask != null ? [addedTask!] : [];
    });

    when(() => mockNotif.scheduleReminderForTask(any()))
        .thenAnswer((_) async {});

    // Act
    await controller.addTask(userId, 'Test Task', '');

    // Assert repository and notification calls
    verify(() => mockRepository.addTask(userId, any())).called(1);
    verify(() => mockNotif.scheduleReminderForTask(any())).called(1);

    // Assert that the task list contains the new task
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

  test('updateTask should modify task in the list and schedule notification',
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
    );

    when(() => mockRepository.updateTask(userId, updatedTask))
        .thenAnswer((_) async {});
    when(() => mockNotif.scheduleReminderForTask(any()))
        .thenAnswer((_) async {});

    await controller.updateTask(userId, updatedTask);

    verify(() => mockNotif.scheduleReminderForTask(any())).called(1);
    expect(controller.tasks.first.title, 'Updated Task');
  });

  test('deleteTask should remove task from list and cancel notifications',
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
    when(() => mockNotif.cancelReminder(any())).thenAnswer((_) async {});

    await controller.deleteTask(userId, sampleTask.id);

    // Task list should be empty
    expect(controller.tasks.isEmpty, true);

    // Verify that notifications were cancelled
    final baseId = sampleTask.id.codeUnits.fold(0, (prev, el) => prev + el);
    verify(() => mockNotif.cancelReminder(baseId)).called(1);
    for (var wd = 1; wd <= 7; wd++) {
      verify(() => mockNotif.cancelReminder(baseId + wd)).called(1);
    }
  });
}
