import 'package:flutter/material.dart';
import 'package:todolist/const/theme.dart';

class SheetButton extends StatelessWidget {
  const SheetButton({super.key, required this.title, required this.color});

  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      height: 52,
      width: double.infinity,
      child: Center(
        child: Text(
          title,
          style: titleStyle.copyWith(fontSize: 20, color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
