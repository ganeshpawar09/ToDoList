import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todolist/const/theme.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    Key? key,
    required this.title,
    required this.hint,
    required this.isDarkModeEnabled,
    required this.widget,
    required this.function,
  }) : super(key: key);

  final String title, hint;
  final bool isDarkModeEnabled;
  final Widget? widget;
  final void Function(bool start) function;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle.copyWith(
                  fontSize: 18,
                  color: (isDarkModeEnabled) ? Colors.white : Colors.black),
            ),
            Container(
              height: 52,
              padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                onTap: () {
                  function;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hint,
                      style: titleStyle.copyWith(
                          color: (isDarkModeEnabled)
                              ? Colors.white
                              : Colors.black),
                    ),
                    Container(
                      child: widget,
                    ),
                    const SizedBox(
                      width: 2,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
