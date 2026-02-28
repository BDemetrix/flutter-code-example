import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide Group, State;

import '../../../core/errors/failures/failures.dart';
import '../../../data/providers/websocket/i_websocket_provider.dart';
import '../../../data/repositories/abonent_repository.dart';
import '../../../data/repositories/group_repository.dart';
import '../../../domain/aggregates/contacts/contacts_aggregate.dart';
import '../../../domain/aggregates/contacts/search_contacts_usecase.dart';
import '../../../presentation/bloc/contacts/contacts_cubit.dart';
import 'contacts_view.dart';

/// Страница контактов
/// Отображает список абонентов и групп с возможностью поиска
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();
  late ContactsCubit _contactsCubit;

  @override
  void initState() {
    super.initState();
    final wsProvider = ExampleWebSocketProvider();
    _contactsCubit = ContactsCubit(
      contactsAggregate: ContactsAggregate(
        abonentRepository: AbonentRepository(webSocketProvider: wsProvider),
        groupRepository: GroupRepository(webSocketProvider: wsProvider),
      ),
      searchContactsUseCase: SearchContactsUseCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contactsCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Контакты'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                onChanged: (value) {
                  _contactsCubit.searchContacts(value);
                },
              ),
            ),
          ),
        ),
        body: const ContactsView(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

/// Заглушка WebSocket провайдера для примера
class ExampleWebSocketProvider implements IWebSocketProvider<String> {
  @override
  Future<Either<Failure, void>> login(String data) async => const Right(null);

  @override
  void send(String message) {}

  @override
  Stream<Either<Failure, Map<String, dynamic>>> get stream =>
      const Stream.empty();

  @override
  String? get serverUri => null;

  @override
  bool get loggedIn => false;
}
