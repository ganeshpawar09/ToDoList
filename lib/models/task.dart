import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Task {
  String title, note;
  int day, weekday;
  DateTime startingDate;
  DateTime dueDate;
  Color color;
  bool isCompleted;
  String taskid;
  String priority;
  bool wantsReminder;
  TimeOfDay startingTime;
  TimeOfDay endTime;
  int remindBefore;
  int remindAfterEvery;

  Task({
    required this.title,
    required this.note,
    required this.day,
    required this.weekday,
    required this.startingDate,
    required this.dueDate,
    required this.color,
    required this.isCompleted,
    required this.taskid,
    required this.priority,
    required this.wantsReminder,
    required this.startingTime,
    required this.endTime,
    required this.remindBefore,
    required this.remindAfterEvery,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'day': day,
      'weekday': weekday,
      'startingDate': startingDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'color': color.value,
      'isCompleted': isCompleted ? 1 : 0,
      'taskid': taskid,
      'priority': priority,
      'wantsReminder': wantsReminder ? 1 : 0,
      'startingTime': '${startingTime.hour}:${startingTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'remindBefore': remindBefore,
      'remindAfterEvery': remindAfterEvery,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final startingTimeParts = map['startingTime'].split(':');
    final endTimeParts = map['endTime'].split(':');
    return Task(
      title: map['title'],
      note: map['note'],
      day: map['day'],
      weekday: map['weekday'],
      startingDate: DateTime.parse(map['startingDate']),
      dueDate: DateTime.parse(map['dueDate']),
      color: Color(map['color']),
      isCompleted: map['isCompleted'] == 1,
      taskid: map['taskid'],
      priority: map['priority'],
      wantsReminder: map['wantsReminder'] == 1,
      startingTime: TimeOfDay(
        hour: int.parse(startingTimeParts[0]),
        minute: int.parse(startingTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      remindBefore: map['remindBefore'],
      remindAfterEvery: map['remindAfterEvery'],
    );
  }
}
