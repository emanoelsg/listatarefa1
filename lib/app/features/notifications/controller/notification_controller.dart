// app/features/notifications/controller/notification_controller.dart
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:listatarefa1/app/features/notifications/service/notifications_service.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';

class NotificationController extends GetxController {
  final NotificationService service;

  NotificationController({required this.service});

  @override
  void onInit() {
    super.onInit();
    service.init();
  }

  Future<void> scheduleReminderForTask(TaskEntity task) async {
    await service.scheduleTaskNotification(task);
  }

  Future<void> cancelReminder(int id) async {
    await service.cancelNotification(id);
  }

  Future<void> cancelRemindersForTask(TaskEntity task) async {
    await service.cancelAllForTask(task);
  }
}
