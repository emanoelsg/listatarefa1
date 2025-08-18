// app/features/notifications/utils/notification_helper.dart
class NotificationHelper {
  static int generateNotificationId(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch.remainder(100000);
  }

  static String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} às ${dateTime.hour}:${dateTime.minute}';
  }
}
