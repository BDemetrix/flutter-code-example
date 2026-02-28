import 'package:flutter/material.dart';

import '../../../domain/entities/group/group.dart';
import 'group_avatar.dart';

/// Виджет элемента группы в списке контактов
class GroupItem extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupItem({
    super.key,
    required this.group,
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
        leading: const GroupAvatar(),
        title: Text(
          group.name,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
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
