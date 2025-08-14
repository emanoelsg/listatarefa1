// test/lib/app/features/tasks/presentation/task_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_repository.dart';
import 'package:listatarefa1/app/features/tasks/presentation/task_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class FakeTaskEntity extends Fake implements TaskEntity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TaskController controller;
  late MockTaskRepository mockRepository;

  const userId = 'user123';
  final sampleTask = TaskEntity(
    id: 'task1',
    title: 'Test Task',
    userId: userId,
    createdAt: DateTime(2023, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeTaskEntity());
  });

  setUp(() {
    mockRepository = MockTaskRepository();
    controller = TaskController(repository: mockRepository);
  });

  test('addTask should call repository and reload tasks', () async {
    when(() => mockRepository.addTask(any(), any())).thenAnswer((_) async {});
    when(() => mockRepository.getTasks(userId))
        .thenAnswer((_) async => [sampleTask]);

    await controller.addTask(userId, 'Test Task', '');

    verify(() => mockRepository.addTask(userId, any())).called(1);
    expect(controller.tasks.length, 1);
    expect(controller.tasks.first.title, 'Test Task');
  });

  test('loadTasks should fetch tasks and update state', () async {
    when(() => mockRepository.getTasks(userId))
        .thenAnswer((_) async => [sampleTask]);

    await controller.loadTasks(userId);

    expect(controller.tasks.length, 1);
    expect(controller.tasks.first.title, 'Test Task');
    expect(controller.isLoading.value, false);
  });

  test('updateTask should modify task in list', () async {
    controller.tasks.value = [sampleTask];

    final updatedTask = TaskEntity(
      id: 'task1',
      title: 'Updated Task',
      userId: userId,
      createdAt: sampleTask.createdAt,
    );

    when(() => mockRepository.updateTask(userId, updatedTask))
        .thenAnswer((_) async {});

    await controller.updateTask(userId, updatedTask);

    expect(controller.tasks.first.title, 'Updated Task');
  });

  test('deleteTask should remove task from list', () async {
    controller.tasks.value = [sampleTask];

    when(() => mockRepository.deleteTask(userId, sampleTask.id))
        .thenAnswer((_) async {});

    await controller.deleteTask(userId, sampleTask.id);

    expect(controller.tasks.isEmpty, true);
  });
}
