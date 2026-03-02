import 'package:flutter/material.dart';

class TitleTaskList extends StatelessWidget {
  final String text;
  final Color? color;
  const TitleTaskList({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: color),
    );
  }
}
