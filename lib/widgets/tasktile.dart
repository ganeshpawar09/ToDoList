import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    String convert(DateTime date) {
      return DateFormat.yMMMd().format(date);
    }

    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: task.color.withOpacity(0.7),
      ),
      child: Row(
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task.isCompleted ? "COMPLETE" : "TODO",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'lato',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'lato',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${convert(task.startingDate)} - ${convert(task.dueDate)}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[100],
                        fontFamily: 'lato',
                      ),
                    ),
                  ],
                ),
                (task.wantsReminder)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: Colors.grey[200],
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${task.startingTime.format(context)} - ${task.endTime.format(context)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[100],
                                  fontFamily: 'lato',
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(height: 5),
                (task.note.isNotEmpty)
                    ? Row(
                        children: [
                          Icon(
                            Icons.notes_rounded,
                            color: Colors.grey[200],
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.note,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[100],
                              fontFamily: 'lato',
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task.priority,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'lato',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
