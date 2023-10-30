import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolist/const/theme.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({super.key, required this.label, required this.onTap});
  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: primaryClr.withOpacity(0.7),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontFamily: 'lato',
                color: white,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
