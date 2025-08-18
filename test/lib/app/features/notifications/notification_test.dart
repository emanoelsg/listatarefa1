// test/lib/app/features/notifications/notification_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:listatarefa1/app/features/notifications/controller/notification_controller.dart';
import 'package:listatarefa1/app/features/notifications/service/notifications_service.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late NotificationController controller;
  late MockNotificationService mockService;

  setUp(() {
    mockService = MockNotificationService();
    controller = NotificationController(service: mockService);
    when(() => mockService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
        )).thenAnswer((_) async {});
  });

  test(
      'scheduleTaskReminder deve chamar scheduleNotification se reminderAt não for nulo',
      () {
    final task = TaskEntity(
      id: 'abc123',
      title: 'Testar notificação',
      userId: 'user1',
      createdAt: DateTime.now(),
      reminderAt: DateTime.now().add(const Duration(minutes: 1)),
    );

    controller.scheduleTaskReminder(task);

    verify(() => mockService.scheduleNotification(
          id: task.id.hashCode,
          title: 'Lembrete de tarefa',
          body: task.title,
          scheduledDate: task.reminderAt!,
        )).called(1);
  });

  test('scheduleTaskReminder não chama nada se reminderAt for nulo', () {
    final task = TaskEntity(
      id: 'abc123',
      title: 'Sem horário',
      userId: 'user1',
      createdAt: DateTime.now(),
      reminderAt: null,
    );

    controller.scheduleTaskReminder(task);
    verifyNever(() => mockService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
        ));
  });
  test(
      'cancelNotification deve chamar service.cancelNotification com o id correto',
      () {
    const notificationId = 123;

    when(() => mockService.cancelNotification(notificationId))
        .thenAnswer((_) async {});

    controller.cancelNotification(notificationId);

    verify(() => mockService.cancelNotification(notificationId)).called(1);
  });
  test(
      'scheduleTaskReminder agenda mesmo com data passada (comportamento atual)',
      () {
    final task = TaskEntity(
      id: 'abc123',
      title: 'Tarefa atrasada',
      userId: 'user1',
      createdAt: DateTime.now(),
      reminderAt:
          DateTime.now().subtract(const Duration(minutes: 1)), // ⏰ passada
    );

    controller.scheduleTaskReminder(task);

    verify(() => mockService.scheduleNotification(
          id: task.id.hashCode,
          title: 'Lembrete de tarefa',
          body: task.title,
          scheduledDate: task.reminderAt!,
        )).called(1);
  });
  test(
      'scheduleTaskReminder não lança erro se service.scheduleNotification falhar',
      () {
    final task = TaskEntity(
      id: 'abc123',
      title: 'Tarefa com erro',
      userId: 'user1',
      createdAt: DateTime.now(),
      reminderAt: DateTime.now().add(const Duration(minutes: 1)),
    );

    when(() => mockService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
        )).thenThrow(Exception('Erro simulado'));

    expect(() => controller.scheduleTaskReminder(task), returnsNormally);
  });
}
