import '../../entities/abonent/abonent.dart';
import '../../entities/group/group.dart';

/// UseCase для поиска контактов
class SearchContactsUseCase {
  List<Abonent> searchAbonents(List<Abonent> abonents, String query) {
    if (query.isEmpty) return abonents;
    return abonents.where((abonent) {
      return abonent.name.toLowerCase().contains(query.toLowerCase()) ||
          (abonent.login.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  List<Group> searchGroups(List<Group> groups, String query) {
    if (query.isEmpty) return groups;
    return groups.where((group) {
      return group.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  ({List<Abonent> abonents, List<Group> groups}) searchContacts(
    List<Abonent> abonents,
    List<Group> groups,
    String query,
  ) {
    if (query.isEmpty) {
      return (abonents: abonents, groups: groups);
    }

    final filteredAbonents = searchAbonents(abonents, query);
    final filteredGroups = searchGroups(groups, query);

    return (abonents: filteredAbonents, groups: filteredGroups);
  }
}
