import '../../../domain/entities/abonent/abonent.dart';
import '../../../domain/entities/group/group.dart';

/// Базовый класс для состояний контактов
abstract class ContactsState {}

/// Начальное состояние
class ContactsInitial extends ContactsState {}

/// Загрузка
class ContactsLoading extends ContactsState {}

/// Успешная загрузка
class ContactsLoaded extends ContactsState {
  final List<Abonent> abonents;
  final List<Group> groups;
  final String? searchQuery;

  ContactsLoaded({
    required this.abonents,
    required this.groups,
    this.searchQuery,
  });

  ContactsLoaded copyWith({
    List<Abonent>? abonents,
    List<Group>? groups,
    String? searchQuery,
  }) {
    return ContactsLoaded(
      abonents: abonents ?? this.abonents,
      groups: groups ?? this.groups,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Ошибка
class ContactsError extends ContactsState {
  final String message;

  ContactsError(this.message);
}
