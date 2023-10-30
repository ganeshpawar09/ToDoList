import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todolist/main.dart';
import 'package:todolist/models/task.dart'; // Assuming this is your task model
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _timeZonesInitialized = false;

  NotificationManager(this._notificationsPlugin);

  void initializeNotifications() async {
    tz.initializeTimeZones();
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/done');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(Task task, bool isDeleted, bool upDated) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'taskAddDeleteCompleted',
      'Notification Channel Name',
      priority: Priority.max,
      importance: Importance.max,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    if (upDated) {
      await _notificationsPlugin.show(
          0, 'Task Updated', task.title, notificationDetails);
    } else if (isDeleted) {
      await _notificationsPlugin.show(
          0, 'Task Deleted', task.title, notificationDetails);
    } else if (task.isCompleted) {
      await _notificationsPlugin.show(
          0, 'Task Completed', task.title, notificationDetails);
    } else {
      await _notificationsPlugin.show(
        0,
        'New Task Added',
        task.title,
        notificationDetails,
      );
    }
  }

  Future<void> scheduleTaskNotifications(Task task) async {
    if (!task.wantsReminder) return;

    final DateTime now = DateTime.now();
    final DateTime startingDateTime = DateTime(
      task.startingDate.year,
      task.startingDate.month,
      task.startingDate.day,
      task.startingTime.hour,
      task.startingTime.minute,
    );
    final DateTime endDateTime = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
      task.endTime.hour,
      task.endTime.minute,
    );

    if (task.remindBefore != 0 &&
        startingDateTime
            .subtract(Duration(minutes: task.remindBefore))
            .isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        task.taskid.hashCode,
        'Reminder: ${task.title}',
        'Starting in ${task.remindBefore} minutes',
        tz.TZDateTime.from(
          startingDateTime.subtract(Duration(minutes: task.remindBefore)),
          tz.local,
        ),
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'remindBefore',
          'Notification Channel Name',
          priority: Priority.max,
          importance: Importance.max,
        )),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print(startingDateTime.subtract(Duration(minutes: task.remindBefore)));
    }
    if (task.remindAfterEvery != 0) {
      int intervalHours = task.remindAfterEvery;

      DateTime notificationTime =
          startingDateTime.add(Duration(hours: intervalHours));
      int i = 1;

      while (notificationTime.isBefore(endDateTime)) {
        if (notificationTime.isAfter(now)) {
          await _notificationsPlugin.zonedSchedule(
            task.taskid.hashCode + i,
            'Reminder: ${task.title}',
            'Time to complete the task',
            tz.TZDateTime.from(notificationTime, tz.local),
            const NotificationDetails(
                android: AndroidNotificationDetails(
              'remindAfter',
              'Notification Channel Name',
              priority: Priority.max,
              importance: Importance.max,
            )),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
        notificationTime =
            notificationTime.add(Duration(hours: intervalHours));
        i += 1;
      }
    }
  }

  Future<void> cancelScheduledNotification(Task task) async {
    if (!task.wantsReminder) return;

    final DateTime startingDateTime = DateTime(
      task.startingDate.year,
      task.startingDate.month,
      task.startingDate.day,
      task.startingTime.hour,
      task.startingTime.minute,
    );
    final DateTime endDateTime = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
      task.endTime.hour,
      task.endTime.minute,
    );
    if (task.remindBefore != 0) {
      await _notificationsPlugin.cancel(task.taskid.hashCode);
    }
    if (task.remindAfterEvery != 0) {
      int intervalHours = task.remindAfterEvery;

      DateTime notificationTime =
          startingDateTime.add(Duration(minutes: intervalHours));
      int i = 1;

      while (notificationTime.isBefore(endDateTime)) {
        await _notificationsPlugin.cancel(
          task.taskid.hashCode + i,
        );
        notificationTime =
            notificationTime.add(Duration(minutes: intervalHours));
        i += 1;
      }
    }
  }
}
