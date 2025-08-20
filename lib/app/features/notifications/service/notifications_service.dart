// app/features/notifications/service/notifications_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  Future<void> scheduleTaskNotification(TaskEntity task) async {
    final androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Tarefas',
      channelDescription: 'Lembretes de tarefas',
      importance: Importance.max,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);

    // Recorrente (daily/weekly) via reminderTime
    if ((task.repeatType == 'daily' || task.repeatType == 'weekly') &&
        task.reminderTime != null) {
      final parts = task.reminderTime!.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (task.repeatType == 'daily') {
        await _plugin.zonedSchedule(
          task.id.hashCode,
          'Lembrete de tarefa',
          task.title,
          _nextInstanceOfTime(hour, minute),
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } else if (task.weekDays != null && task.weekDays!.isNotEmpty) {
        for (final wd in task.weekDays!) {
          await _plugin.zonedSchedule(
            task.id.hashCode + wd,
            'Lembrete de tarefa',
            task.title,
            _nextInstanceOfWeekdayTime(wd, hour, minute),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
        }
      }
      return;
    }

    // Única vez via reminderAt
    if (task.reminderAt != null) {
      await _plugin.zonedSchedule(
        task.id.hashCode,
        'Lembrete de tarefa',
        task.title,
        tz.TZDateTime.from(task.reminderAt!, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelNotification(int id) async => _plugin.cancel(id);

  Future<void> cancelAllForTask(TaskEntity task) async {
    await _plugin.cancel(task.id.hashCode);
    for (var wd = 1; wd <= 7; wd++) {
      await _plugin.cancel(task.id.hashCode + wd);
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfWeekdayTime(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }
    return scheduled;
  }
}
