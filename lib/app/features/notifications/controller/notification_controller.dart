// app/features/notifications/controller/notification_controller.dart
import 'package:get/get.dart';
import '../service/notifications_service.dart';
import '../../tasks/domain/task_entity.dart';

class NotificationController extends GetxController {
  final NotificationService service;

  NotificationController({required this.service});
  @override
  void onInit() {
    super.onInit();
    service.init();
  }

  /// Agenda ou atualiza a notificação da tarefa
  Future<void> scheduleTaskReminder(TaskEntity task) async {
    if (task.reminderAt == null) return;
    await service.scheduleTaskNotification(task);
  }

  /// Cancela uma notificação pelo ID
  Future<void> cancelNotification(int id) async {
    await service.cancelNotification(id);
  }

  /// Cancela todas as notificações relacionadas a uma tarefa
  Future<void> cancelAllForTask(TaskEntity task) async {
    await service.cancelAllForTask(task);
  }
}
