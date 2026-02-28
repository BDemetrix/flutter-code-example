import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/aggregates/contacts/contacts_aggregate.dart';
import '../../../domain/aggregates/contacts/search_contacts_usecase.dart';
import '../../../domain/entities/abonent/abonent.dart';
import '../../../domain/entities/group/group.dart';
import 'contacts_state.dart';

/// Cubit для управления состоянием контактов
class ContactsCubit extends Cubit<ContactsState> {
  final ContactsAggregate _contactsAggregate;
  final SearchContactsUseCase _searchContactsUseCase;
  StreamSubscription? _contactsSubscription;

  // Храним оригинальные ОТСОРТИРОВАННЫЕ данные из Aggregate
  List<Abonent> _sortedAbonents = [];
  List<Group> _sortedGroups = [];
  String? _currentSearchQuery;

  ContactsCubit({
    required ContactsAggregate contactsAggregate,
    required SearchContactsUseCase searchContactsUseCase,
  }) : _contactsAggregate = contactsAggregate,
       _searchContactsUseCase = searchContactsUseCase,
       super(ContactsInitial()) {
    loadContacts();
  }

  void loadContacts() {
    emit(ContactsLoading());

    _contactsSubscription?.cancel();

    _contactsSubscription = _contactsAggregate.stream.listen(
      (result) {
        result.fold(
          (failure) => emit(ContactsError(failure.toString())),
          (contactsData) {
            // Сохраняем ОТСОРТИРОВАННЫЕ данные из Aggregate
            _sortedAbonents = contactsData.abonents;
            _sortedGroups = contactsData.groups;

            // Применяем текущий поисковый запрос если есть
            if (_currentSearchQuery != null &&
                _currentSearchQuery!.isNotEmpty) {
              _applySearch(_currentSearchQuery!);
            } else {
              emit(ContactsLoaded(
                abonents: _sortedAbonents,
                groups: _sortedGroups,
              ));
            }
          },
        );
      },
      onError: (error) {
        emit(ContactsError(error.toString()));
      },
    );
  }

  void searchContacts(String query) {
    _currentSearchQuery = query.isNotEmpty ? query : null;

    if (_currentSearchQuery == null) {
      emit(ContactsLoaded(abonents: _sortedAbonents, groups: _sortedGroups));
    } else {
      _applySearch(_currentSearchQuery!);
    }
  }

  void _applySearch(String query) {
    final filteredContacts = _searchContactsUseCase.searchContacts(
      _sortedAbonents,
      _sortedGroups,
      query,
    );

    emit(ContactsLoaded(
      abonents: filteredContacts.abonents,
      groups: filteredContacts.groups,
      searchQuery: query,
    ));
  }

  void clearSearch() {
    searchContacts('');
  }

  void refreshContacts() {
    loadContacts();
  }

  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }
}
