import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/const/theme.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/provider/taskprovider.dart';
import 'package:todolist/widgets/sheet_button.dart';
import 'package:todolist/widgets/tasktile.dart';

class HomeScreenList extends ConsumerStatefulWidget {
  const HomeScreenList({super.key, required this.list});
  final List<Task> list;
  @override
  ConsumerState<HomeScreenList> createState() => _HomeScreenListState();
}

class _HomeScreenListState extends ConsumerState<HomeScreenList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return Slidable(
            closeOnScroll: true,
            endActionPane: ActionPane(motion: ScrollMotion(), children: [
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.share,
                label: 'Share',
              ),
            ]),
            child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    context: context,
                    builder: (context) {
                      return Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: MediaQuery.of(context).size.height * 0.32,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            (!widget.list[index].isCompleted)
                                ? GestureDetector(
                                    onTap: () {
                                      Task total = widget.list[index];
                                      ref
                                          .read(taskProvider.notifier)
                                          .deleteTotal(
                                              widget.list[index].taskid);
                                      total.isCompleted = true;
                                      ref
                                          .read(taskProvider.notifier)
                                          .addTotal(total, true);
                                      Navigator.pop(context);
                                    },
                                    child: const SheetButton(
                                        title: "Completed", color: bluishclr),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                                onTap: () {
                                  ref
                                      .read(taskProvider.notifier)
                                      .deleteTotal(widget.list[index].taskid);
                                  Navigator.pop(context);
                                },
                                child: const SheetButton(
                                    title: "Delete", color: pinkClr)),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const SheetButton(
                                  title: "Cancel", color: Color(808080)),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: TaskTile(widget.list[index])),
          );
        },
      ),
    );
  }
}
