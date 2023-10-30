import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:todolist/main.dart';
import 'package:todolist/provider/notification.dart';
import 'package:uuid/uuid.dart';
import 'package:todolist/const/theme.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/provider/taskprovider.dart';
import 'package:todolist/widgets/home_button.dart';
import 'package:todolist/widgets/input_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen(
      {Key? key,
      required this.isDarkModeEnabled,
      required this.edit,
      this.task})
      : super(key: key);
  final bool isDarkModeEnabled;
  final bool edit;
  final Task? task;

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  double _currentSliderValue = 1.0;

  List<Color> colorList = [bluishclr, yellowclr, pinkClr];
  var remindlist = ["None", 1, 5, 10, 15];
  var remindeAfterEveryList = ["None", 1, 2, 3, 4, 5];
  List<String> priorityList = ["High", "Medium", "Low"];

  var remind = "None";
  var remindAfterEvery = "None";
  String priority = "High";
  bool isCompleted = false;

  DateTime startingDate = DateTime.now();
  DateTime dueDate = DateTime.now();
  TimeOfDay endTime = const TimeOfDay(hour: 23, minute: 00);
  TimeOfDay startingTime = TimeOfDay.now();

  bool isCheck = false;
  bool initialised = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  void _changeDate(bool start) async {
    await showDatePicker(
      context: context,
      initialDate: start ? startingDate : dueDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    ).then((value) {
      if (value != null) {
        setState(() {
          if (start) {
            startingDate = value;
          } else {
            dueDate = value;
          }
        });
      }
    });
  }

  void _changeTime(bool start) async {
    await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: (start) ? startingTime : endTime,
    ).then((value) {
      if (value != null) {
        setState(() {
          if (start) {
            startingTime = value;
          } else {
            endTime = value;
          }
        });
      }
    });
  }

  void _createTask() async {
    try {
      if (titleController.text.isNotEmpty) {
        Task task = Task(
          day: startingDate.day,
          weekday: startingDate.weekday,
          dueDate: dueDate,
          title: titleController.text,
          note: noteController.text,
          startingDate: startingDate,
          color: (priority == "Low")
              ? bluishclr
              : (priority == "Medium")
                  ? yellowclr
                  : pinkClr,
          isCompleted: isCompleted,
          priority: priority,
          wantsReminder: isCheck,
          startingTime: startingTime,
          endTime: endTime,
          remindBefore: (remind == "None") ? 0 : int.parse(remind),
          remindAfterEvery:
              (remindAfterEvery == "None") ? 0 : int.parse(remindAfterEvery),
          taskid: Uuid().v4(),
        );
        NotificationManager notificationManager =
            NotificationManager(notificationsPlugin);
        if (widget.edit) {
          Task task = widget.task!;
          ref.read(taskProvider.notifier).deleteTotal(widget.task!.taskid);
          await notificationManager.cancelScheduledNotification(task);
        }
        ref.read(taskProvider.notifier).addTotal(task, false);
        Navigator.pop(context);

        await notificationManager.showNotification(task, false, widget.edit);
        await notificationManager.scheduleTaskNotifications(task);
      } else {}
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.edit && !initialised) {
      titleController.text = widget.task!.title;
      noteController.text = widget.task!.note;
      isCheck = widget.task!.wantsReminder;
      startingDate = widget.task!.startingDate;
      dueDate = widget.task!.dueDate;
      startingTime = widget.task!.startingTime;

      endTime = widget.task!.endTime;
      remind = (widget.task!.remindBefore).toString();
      remindAfterEvery = widget.task!.remindBefore.toString();

      _currentSliderValue =
          (priorityList.length - priorityList.indexOf(widget.task!.priority)) /
              1.0;
      initialised = true;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: (widget.isDarkModeEnabled)
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Text(
                      "Task",
                      style: subHeadlineStyle.copyWith(
                          color: (widget.isDarkModeEnabled)
                              ? Colors.white
                              : Colors.black),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                InputField(
                  title: "Title",
                  hint: "Enter title here",
                  isDarkModeEnabled: widget.isDarkModeEnabled,
                  controller: titleController,
                ),
                const SizedBox(
                  height: 5,
                ),
                InputField(
                  title: "Note",
                  hint: "Enter note here",
                  isDarkModeEnabled: widget.isDarkModeEnabled,
                  controller: noteController,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Priority",
                  style: titleStyle.copyWith(
                      fontSize: 18,
                      color: (widget.isDarkModeEnabled)
                          ? Colors.white
                          : Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "    Low",
                      style: subtitleStyle,
                    ),
                    Text(
                      "Medium",
                      style: subtitleStyle,
                    ),
                    Text(
                      "High    ",
                      style: subtitleStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 30,
                    tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 16),
                    trackShape: RoundedRectSliderTrackShape(),
                    valueIndicatorShape: DropSliderValueIndicatorShape(),
                  ),
                  child: Slider(
                    activeColor: (_currentSliderValue == 1)
                        ? bluishclr.withOpacity(.8)
                        : (_currentSliderValue == 2)
                            ? yellowclr.withOpacity(.8)
                            : pinkClr.withOpacity(.8),
                    value: _currentSliderValue,
                    max: 3,
                    min: 1,
                    divisions: 2,
                    thumbColor: Colors.white,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        priority = priorityList[
                            priorityList.length - _currentSliderValue.toInt()];
                      });
                    },
                  ),
                ),

                // InputField(
                //   title: "Priority",
                //   hint: priority,
                //   isDarkModeEnabled: widget.isDarkModeEnabled,
                //   widget: Row(
                //     children: [
                //       DropdownButton<String>(
                //         icon: const Icon(
                //           Icons.keyboard_arrow_down,
                //           color: Colors.grey,
                //         ),
                //         iconSize: 32,
                //         elevation: 4,
                //         style: subtitleStyle,
                //         borderRadius: BorderRadius.circular(10),
                //         underline: Container(
                //           height: 0,
                //         ),
                //         onChanged: (newValue) {
                //           setState(() {
                //             priority = newValue.toString();
                //           });
                //         },
                //         items: priorityList.map<DropdownMenuItem<String>>(
                //           (String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(value),
                //             );
                //           },
                //         ).toList(),
                //       ),
                //       const SizedBox(
                //         width: 20,
                //       )
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: "Starting Date",
                        hint: DateFormat.yMMMd().format(startingDate),
                        isDarkModeEnabled: widget.isDarkModeEnabled,
                        widget: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () {
                            _changeDate(true);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InputField(
                        title: "Due Date",
                        hint: DateFormat.yMMMd().format(dueDate),
                        isDarkModeEnabled: widget.isDarkModeEnabled,
                        widget: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () {
                            _changeDate(false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        activeColor: bluishclr,
                        value: isCheck,
                        onChanged: (value) {
                          setState(
                            () {
                              isCheck = value!;
                            },
                          );
                        },
                      ),
                    ),
                    Text(
                      "Remind me",
                      style: titleStyle,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                (isCheck)
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  title: "Starting Time",
                                  hint: startingTime.format(context),
                                  isDarkModeEnabled: widget.isDarkModeEnabled,
                                  widget: IconButton(
                                    icon:
                                        const Icon(Icons.access_time_outlined),
                                    onPressed: () {
                                      _changeTime(true);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InputField(
                                  title: "End Time",
                                  hint: endTime.format(context),
                                  isDarkModeEnabled: widget.isDarkModeEnabled,
                                  widget: IconButton(
                                    icon:
                                        const Icon(Icons.access_time_outlined),
                                    onPressed: () {
                                      _changeTime(false);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputField(
                            title: "Remind (Minute)",
                            hint: (remind == "None")
                                ? "None"
                                : "$remind minutes early",
                            isDarkModeEnabled: widget.isDarkModeEnabled,
                            widget: Row(
                              children: [
                                DropdownButton<String>(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  iconSize: 32,
                                  elevation: 4,
                                  style: subtitleStyle,
                                  borderRadius: BorderRadius.circular(10),
                                  underline: Container(
                                    height: 0,
                                  ),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        remind = newValue;
                                      });
                                    }
                                  },
                                  items:
                                      remindlist.map<DropdownMenuItem<String>>(
                                    (dynamic value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text("$value"),
                                      );
                                    },
                                  ).toList(),
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputField(
                            title: "Remind after every (Hour)",
                            hint: (remindAfterEvery == "None")
                                ? "None"
                                : "$remindAfterEvery hours",
                            isDarkModeEnabled: widget.isDarkModeEnabled,
                            widget: Row(
                              children: [
                                DropdownButton<String>(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  iconSize: 32,
                                  elevation: 4,
                                  style: subtitleStyle,
                                  borderRadius: BorderRadius.circular(10),
                                  underline: Container(
                                    height: 0,
                                  ),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        remindAfterEvery = newValue;
                                      });
                                    }
                                  },
                                  items: remindeAfterEveryList
                                      .map<DropdownMenuItem<String>>(
                                    (dynamic value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text("$value"),
                                      );
                                    },
                                  ).toList(),
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const SizedBox(
                    //       height: 16,
                    //     ),
                    //     Text(
                    //       "Color",
                    //       style: titleStyle.copyWith(
                    //           fontSize: 18,
                    //           color: (widget.isDarkModeEnabled)
                    //               ? Colors.white
                    //               : Colors.black),
                    //     ),
                    //     const SizedBox(
                    //       height: 5,
                    //     ),
                    //     Wrap(
                    //       children: List<Widget>.generate(
                    //         3,
                    //         (index) => GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               selectedColor = index;
                    //             });
                    //           },
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(5.0),
                    //             child: CircleAvatar(
                    //               radius: 14,
                    //               backgroundColor: colorList[index],
                    //               child: (selectedColor == index)
                    //                   ? const Icon(
                    //                       Icons.done,
                    //                       color: Colors.white,
                    //                     )
                    //                   : null,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: HomeButton(
                        label: "Create",
                        onTap: _createTask,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 200,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
