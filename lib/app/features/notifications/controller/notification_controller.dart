// app/features/notifications/controller/notification_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/notifications/service/notifications_service.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';

class NotificationController extends GetxController {
  final NotificationService service;

  NotificationController({required this.service});

void scheduleTaskReminder(TaskEntity task) {
  if (task.reminderAt == null) return;

  final int notificationId = task.id.hashCode;

  try {
    service.scheduleNotification(
      id: notificationId,
      title: 'Lembrete de tarefa',
      body: task.title,
      scheduledDate: task.reminderAt!,
    );
  } catch (e) {
    // Você pode logar o erro ou ignorar silenciosamente
    debugPrint('Erro ao agendar notificação: $e');
  }
}

  void cancelNotification(int id) {
    service.cancelNotification(id);
  }
}
