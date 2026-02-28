import '../group/group.dart';

/// Базовый класс для payload групп
sealed class GroupPayload {}

/// Список групп
class GroupListPayload extends GroupPayload {
  final List<Group> groups;
  GroupListPayload(this.groups);
}

/// ID групп для удаления
class GroupIdsPayload extends GroupPayload {
  final List<String> groupId;
  GroupIdsPayload(this.groupId);
}
