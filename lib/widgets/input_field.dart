import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todolist/const/theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    required this.isDarkModeEnabled,
    this.controller,
    this.widget,
    this.function,
  }) : super(key: key);

  final String title, hint;
  final TextEditingController? controller;
  final bool isDarkModeEnabled;
  final Widget? widget;
  final void Function(bool start)? function;

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: widget == null ? false : true,
                      autofocus: false,
                      controller: controller,
                      style: titleStyle.copyWith(
                          color: (isDarkModeEnabled)
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: subtitleStyle,
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  widget == null
                      ? Container()
                      : Container(
                          child: widget,
                        ),
                  const SizedBox(
                    width: 2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
