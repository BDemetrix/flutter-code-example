import 'package:flutter/material.dart';

import '../../../domain/entities/abonent/abonent.dart';
import 'abonent_avatar.dart';

/// Виджет элемента абонента в списке контактов
class AbonentItem extends StatelessWidget {
  final Abonent contact;
  final VoidCallback onTap;

  const AbonentItem({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: AbonentAvatar(abonent: contact),
        title: Text(
          contact.name,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          contact.login,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
