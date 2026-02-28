import 'package:flutter/material.dart';

/// Виджет аватара группы
class GroupAvatar extends StatelessWidget {
  const GroupAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Colors.grey,
      child: Icon(Icons.group, color: Colors.white),
    );
  }
}
