import 'dart:math';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:todolist/const/theme.dart';
import 'package:todolist/main.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/pages/add_task.dart';
import 'package:todolist/provider/notification.dart';
import 'package:todolist/widgets/home_button.dart';
import 'package:todolist/widgets/home_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/provider/taskprovider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/widgets/sheet_button.dart';
import 'package:todolist/widgets/tasktile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage(
      {super.key, required this.toggleTheme, required this.isDarkModeEnabled});

  final void Function() toggleTheme;
  final bool isDarkModeEnabled;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<void> _totalFuture;

  @override
  void initState() {
    _totalFuture = ref.read(taskProvider.notifier).getTotals();
    super.initState();
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    bool checkCompletion(Task todoItem, DateTime currentDate) {
      DateTime startDateOnly = DateTime(todoItem.startingDate.year,
          todoItem.startingDate.month, todoItem.startingDate.day);
      DateTime dueDateOnly = DateTime(
          todoItem.dueDate.year, todoItem.dueDate.month, todoItem.dueDate.day);
      DateTime currentDateOnly =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      if (currentDateOnly.isAtSameMomentAs(startDateOnly) ||
          currentDateOnly.isAtSameMomentAs(dueDateOnly)) {
        return true;
      } else if (currentDateOnly.isAfter(startDateOnly) &&
          currentDateOnly.isBefore(dueDateOnly)) {
        return true;
      } else {
        return false;
      }
    }

    String getGreetingMessage() {
      var now = DateTime.now();
      var hour = now.hour;

      if (hour >= 0 && hour < 12) {
        return "Good Morning";
      } else if (hour >= 12 && hour < 17) {
        return "Good Afternoon";
      } else {
        return "Good Evening";
      }
    }

    void _changeDate() async {
      await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030),
      ).then((value) {
        if (value != null) {
          setState(() {
            selectedDate = value;
          });
        }
      });
    }

    List<Task> filteredList = ref
        .watch(taskProvider)
        .where((element) => checkCompletion(element, selectedDate))
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
          title: Text(
            getGreetingMessage(),
            style: subHeadlineStyle.copyWith(
              color: widget.isDarkModeEnabled ? Colors.white : Colors.black,
            ),
          ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadlineStyle.copyWith(
                        color: widget.isDarkModeEnabled
                            ? Colors.grey[400]
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      "Today",
                      style: headlineStyle,
                    ),
                  ],
                ),
                HomeButton(
                  label: "+Add Task",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddTaskScreen(
                          edit: false,
                          isDarkModeEnabled: widget.isDarkModeEnabled,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime(selectedDate.year,
                        selectedDate.month, selectedDate.day - 1);
                  });
                },
                icon: Icon(Icons.keyboard_arrow_left),
                iconSize: 40,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: _changeDate,
                child: Text(
                  DateFormat.yMMMd().format(selectedDate),
                  style: titleStyle,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime(selectedDate.year,
                        selectedDate.month, selectedDate.day + 1);
                  });
                },
                icon: Icon(Icons.keyboard_arrow_right),
                iconSize: 40,
                color: Colors.grey,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredList.length) {
                  return const SizedBox(
                    height: 100,
                  );
                } else {
                  final itemIndex = index;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Slidable(
                      closeOnScroll: true,
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(20),
                            onPressed: (context) async {
                              NotificationManager notificationManager =
                                  NotificationManager(notificationsPlugin);
                              Task total = filteredList[itemIndex];

                              total.isCompleted = !total.isCompleted;
                              if (total.isCompleted) {
                                ref
                                    .read(taskProvider.notifier)
                                    .updateTotal(total);
                                await notificationManager.showNotification(
                                    total, false, true);
                                await notificationManager
                                    .cancelScheduledNotification(total);
                              } else {
                                ref
                                    .read(taskProvider.notifier)
                                    .updateTotal(total);
                                await notificationManager.showNotification(
                                    total, false, true);
                                await notificationManager
                                    .scheduleTaskNotifications(total);
                              }
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: (filteredList[itemIndex].isCompleted)
                                ? Icons.undo
                                : Icons.done,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              Task task = filteredList[itemIndex];
                              ref
                                  .read(taskProvider.notifier)
                                  .deleteTotal(filteredList[itemIndex].taskid);
                              NotificationManager notificationManager =
                                  NotificationManager(notificationsPlugin);
                              await notificationManager.showNotification(
                                  task, true, false);
                              await notificationManager
                                  .cancelScheduledNotification(task);
                            },
                            borderRadius: BorderRadius.circular(16),
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(
                                edit: true,
                                task: filteredList[itemIndex],
                                isDarkModeEnabled: widget.isDarkModeEnabled,
                              ),
                            ),
                          );
                        },
                        child: TaskTile(filteredList[itemIndex]),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         // leading: GestureDetector(
//         //   onTap: widget.toggleTheme,
//         //   child: (widget.isDarkModeEnabled)
//         //       ? const Icon(
//         //           Icons.dark_mode_rounded,
//         //           size: 25,
//         //         )
//         //       : const Icon(
//         //           Icons.light_mode_rounded,
//         //           color: Colors.black,
//         //           size: 25,
//         //         ),
//         // ),
//         title: Text(
//           getGreetingMessage(),
//           style: subHeadlineStyle.copyWith(
//               color: (widget.isDarkModeEnabled) ? Colors.white : Colors.black),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       DateFormat.yMMMMd().format(DateTime.now()),
//                       style: subHeadlineStyle.copyWith(
//                           color: (widget.isDarkModeEnabled)
//                               ? Colors.grey[400]
//                               : Colors.grey),
//                     ),
//                     Text(
//                       "Today",
//                       style: headlineStyle,
//                     ),
//                   ],
//                 ),
//                 HomeButton(
//                   label: "+Add Task",
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => AddTaskScreen(
//                           edit: false,
//                           isDarkModeEnabled: widget.isDarkModeEnabled,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     selectedDate = DateTime(selectedDate.year,
//                         selectedDate.month, selectedDate.day - 1);
//                   });
//                 },
//                 icon: Icon(Icons.keyboard_arrow_left),
//                 iconSize: 40,
//                 color: Colors.grey,
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               GestureDetector(
//                   onTap: _changeDate,
//                   child: Text(
//                     DateFormat.yMMMd().format(selectedDate),
//                     style: titleStyle,
//                   )),
//               const SizedBox(
//                 width: 5,
//               ),
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     selectedDate = DateTime(selectedDate.year,
//                         selectedDate.month, selectedDate.day + 1);
//                   });
//                 },
//                 icon: Icon(Icons.keyboard_arrow_right),
//                 iconSize: 40,
//                 color: Colors.grey,
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredList.length + 1,
//               itemBuilder: (context, index) {
//                 // Container(
//                 //   margin: const EdgeInsets.only(left: 20, bottom: 20),
//                 // child: DatePicker(
//                 //   DateTime.now(),

//                 //   height: 100,
//                 //   width: 80,
//                 //   initialSelectedDate: DateTime.now(),
//                 //   selectionColor: primaryClr,
//                 //   selectedTextColor: Colors.white,
//                 //   dateTextStyle: GoogleFonts.lato().copyWith(
//                 //       fontSize: 20,
//                 //       fontWeight: FontWeight.w600,
//                 //       color: Colors.grey),
//                 //   dayTextStyle: GoogleFonts.lato().copyWith(
//                 //       fontSize: 16,
//                 //       fontWeight: FontWeight.w600,
//                 //       color: Colors.grey),
//                 //   monthTextStyle: GoogleFonts.lato().copyWith(
//                 //       fontSize: 14,
//                 //       fontWeight: FontWeight.w600,
//                 //       color: Colors.grey),
//                 //   onDateChange: (value) {
//                 //     setState(() {
//                 //       selectedDate = value;
//                 //       filteredList = ref
//                 //           .watch(taskProvider)
//                 //           .where((element) =>
//                 //               checkCompletion(element, selectedDate))
//                 //           .toList();
//                 //     });
//                 //   },
//                 // ),
//                 // );
//                 if (index == filteredList.length) {
//                   return const SizedBox(
//                     height: 100,
//                   );
//                 } else {
//                   final itemIndex = index;
//                   return Slidable(
//                     closeOnScroll: true,
//                     endActionPane: ActionPane(
//                       motion: ScrollMotion(),
//                       children: [
//                         SizedBox(
//                           height: 80,
//                           width: 80,
//                           child: SlidableAction(
//                             borderRadius: BorderRadius.circular(16),
//                             onPressed: (context) async {
//                               NotificationManager notificationManager =
//                                   NotificationManager(notificationsPlugin);
//                               Task total = filteredList[itemIndex];

//                               total.isCompleted = !total.isCompleted;
//                               if (total.isCompleted) {
//                                 ref
//                                     .read(taskProvider.notifier)
//                                     .updateTotal(total);
//                                 await notificationManager.showNotification(
//                                     total, false, true);
//                                 await notificationManager
//                                     .cancelScheduledNotification(total);
//                               } else {
//                                 ref
//                                     .read(taskProvider.notifier)
//                                     .updateTotal(total);
//                                 await notificationManager.showNotification(
//                                     total, false, true);
//                                 await notificationManager
//                                     .scheduleTaskNotifications(total);
//                               }
//                             },
//                             backgroundColor: Color(0xFF21B7CA),
//                             foregroundColor: Colors.white,
//                             icon: (filteredList[itemIndex].isCompleted)
//                                 ? Icons.undo
//                                 : Icons.done,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         SizedBox(
//                           height: 80,
//                           width: 80,
//                           child: SlidableAction(
//                             onPressed: (context) async {
//                               Task task = filteredList[itemIndex];
//                               ref
//                                   .read(taskProvider.notifier)
//                                   .deleteTotal(filteredList[itemIndex].taskid);
//                               NotificationManager notificationManager =
//                                   NotificationManager(notificationsPlugin);
//                               await notificationManager.showNotification(
//                                   task, true, false);
//                               await notificationManager
//                                   .cancelScheduledNotification(task);
//                             },
//                             borderRadius: BorderRadius.circular(16),
//                             backgroundColor: Color(0xFFFE4A49),
//                             foregroundColor: Colors.white,
//                             icon: Icons.delete,
//                           ),
//                         ),
//                       ],
//                     ),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => AddTaskScreen(
//                               edit: true,
//                               task: filteredList[itemIndex],
//                               isDarkModeEnabled: widget.isDarkModeEnabled,
//                             ),
//                           ),
//                         );
//                       },
//                       child: TaskTile(
//                         filteredList[itemIndex],
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
