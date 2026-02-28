import 'package:flutter/material.dart';

import '../../../domain/entities/abonent/abonent.dart';

/// Виджет аватара абонента с индикатором онлайн-статуса
class AbonentAvatar extends StatelessWidget {
  final Abonent abonent;

  const AbonentAvatar({
    super.key,
    required this.abonent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        // Индикатор онлайн-статуса
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: abonent.isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).cardColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
