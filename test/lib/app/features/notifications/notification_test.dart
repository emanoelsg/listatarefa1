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
  });

  test(
      'scheduleTaskReminder deve chamar scheduleTaskNotification se reminderAt não for nulo',
      () async {
    final task = TaskEntity(
      id: 'abc123',
      title: 'Testar notificação',
      userId: 'user1',
      createdAt: DateTime.now(),
      reminderAt: DateTime.now().add(const Duration(minutes: 1)),
    );

    when(() => mockService.scheduleTaskNotification(task))
        .thenAnswer((_) async {});

    await controller.scheduleReminderForTask(task);

    verify(() => mockService.scheduleTaskNotification(task)).called(1);
  });

  test('scheduleTaskReminder não chama nada se reminderAt for nulo', () async {
    final task = TaskEntity(
      id: 'abc123',
      title: 'Sem horário',
      userId: 'user1',
      createdAt: DateTime.now(),
      reminderAt: null,
    );

    await controller.scheduleReminderForTask(task);

    verifyNever(() => mockService.scheduleTaskNotification(task));
  });

  test(
      'cancelNotification deve chamar service.cancelNotification com o id correto',
      () async {
    const notificationId = 123;

    when(() => mockService.cancelNotification(notificationId))
        .thenAnswer((_) async {});

    await controller.cancelRemindersForTask(notificationId as TaskEntity);

    verify(() => mockService.cancelNotification(notificationId)).called(1);
  });
}
