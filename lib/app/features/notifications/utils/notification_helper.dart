// app/features/notifications/utils/notification_helper.dart
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';

class NotificationHelper {
  static int baseId(TaskEntity task) => task.id.hashCode;

  static int weeklyId(TaskEntity task, int weekday) =>
      task.id.hashCode + weekday;

  static String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} às '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
