import 'dart:async';

import 'package:fpdart/fpdart.dart' hide Group;

import '../../../core/errors/failures/failures.dart';
import '../../entities/abonent/abonent.dart';
import '../../entities/abonent/abonent_payload.dart';
import '../../entities/group/group.dart';
import '../../entities/group/group_payload.dart';
import '../../entities/operation/operation.dart';
import '../../entities/operation/operation_container.dart';
import '../../repositories/i_abonent_repository.dart';
import '../../repositories/i_group_repository.dart';

/// Данные контактов (абоненты и группы)
class ContactsData {
  final List<Abonent> abonents;
  final List<Group> groups;

  ContactsData({
    required this.abonents,
    required this.groups,
  });
}

/// Агрегат контактов
/// Объединяет данные из репозиториев абонентов и групп
class ContactsAggregate {
  final IAbonentRepository _abonentRepository;
  final IGroupRepository _groupRepository;

  late final StreamController<Either<Failure, ContactsData>> _controller;
  late final StreamSubscription<
    Either<Failure, OperationContainer<AbonentPayload>>
  >
  _abonentRepositoryListener;
  late final StreamSubscription<
    Either<Failure, OperationContainer<GroupPayload>>
  >
  _groupRepositoryListener;

  final Map<String, Abonent> _abonentsMap = {};
  final Map<String, Group> _groupMap = {};

  bool _abonentDone = false;
  bool _groupDone = false;

  ContactsAggregate({
    required IAbonentRepository abonentRepository,
    required IGroupRepository groupRepository,
  }) : _abonentRepository = abonentRepository,
       _groupRepository = groupRepository {
    _controller = StreamController<Either<Failure, ContactsData>>.broadcast();

    _abonentRepositoryListener = _abonentRepository.stream.listen(
      _onAbonentData,
      onError: (Object err, StackTrace st) =>
          _onRepositoryError(err, st, source: 'abonent'),
      onDone: () => _onRepositoryDone(source: 'abonent'),
      cancelOnError: false,
    );

    _groupRepositoryListener = _groupRepository.stream.listen(
      _onGroupData,
      onError: (Object err, StackTrace st) =>
          _onRepositoryError(err, st, source: 'group'),
      onDone: () => _onRepositoryDone(source: 'group'),
      cancelOnError: false,
    );
  }

  Stream<Either<Failure, ContactsData>> get stream => _controller.stream;

  /// Обработка данных от репозитория абонентов
  void _onAbonentData(
    Either<Failure, OperationContainer<AbonentPayload>> result,
  ) {
    result.fold(
      (failure) {
        _controller.add(Left(failure));
      },
      (abonentsMsg) {
        switch (abonentsMsg.operation) {
          case Operation.initialize:
          case Operation.add:
          case Operation.change:
            if (abonentsMsg.data is! AbonentListPayload) break;
            final abonents = (abonentsMsg.data as AbonentListPayload).abonents;
            for (var abonent in abonents) {
              _abonentsMap[abonent.id] = abonent;
            }
            break;
          case Operation.remove:
            if (abonentsMsg.data is! AbonentIdsPayload) break;
            for (var id in (abonentsMsg.data as AbonentIdsPayload).abonentIds) {
              _abonentsMap.remove(id);
            }
            break;
        }

        _emitContactsIfReady();
      },
    );
  }

  /// Обработка данных от репозитория групп
  void _onGroupData(Either<Failure, OperationContainer<GroupPayload>> result) {
    result.fold(
      (failure) {
        _controller.add(Left(failure));
      },
      (groupsMsg) {
        switch (groupsMsg.operation) {
          case Operation.initialize:
          case Operation.add:
          case Operation.change:
            if (groupsMsg.data is! GroupListPayload) break;
            for (var g in (groupsMsg.data as GroupListPayload).groups) {
              _groupMap[g.id] = g;
            }
            break;
          case Operation.remove:
            if (groupsMsg.data is! GroupIdsPayload) break;
            for (var id in (groupsMsg.data as GroupIdsPayload).groupId) {
              _groupMap.remove(id);
            }
            break;
        }

        _emitContactsIfReady();
      },
    );
  }

  /// Общая логика отправки объединённых данных
  void _emitContactsIfReady() {
    final data = ContactsData(
      abonents: _sortAbonents(_abonentsMap.values.toList()),
      groups: _sortGroups(_groupMap.values.toList()),
    );
    _controller.add(Right(data));
  }

  List<Abonent> _sortAbonents(List<Abonent> abonents) {
    return List<Abonent>.from(abonents)
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  List<Group> _sortGroups(List<Group> groups) {
    return List<Group>.from(groups)..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Обработка ошибок
  void _onRepositoryError(
    Object e,
    StackTrace st, {
    required String source,
  }) {
    final sourceStr = source == 'group' ? 'групп' : 'абонентов';
    final errText = 'Сбой потока получения данных $sourceStr';

    if (e is Failure) {
      _controller.add(Left(e));
      return;
    }

    final failure = DataProcessingFailure(message: errText, stackTrace: st);
    _controller.add(Left(failure));
  }

  /// Обработка завершения потоков
  void _onRepositoryDone({required String source}) {
    final errText = source == 'abonent'
        ? 'Поток данных абонентов завершился'
        : 'Поток данных групп завершился';

    final failure = DataProcessingFailure(message: errText);
    _controller.add(Left(failure));

    if (source == 'abonent') _abonentDone = true;
    if (source == 'group') _groupDone = true;

    if (_abonentDone && _groupDone) {
      if (!_controller.isClosed) _controller.close();
    }
  }

  /// Освобождение ресурсов
  Future<void> dispose() async {
    await _abonentRepositoryListener.cancel();
    await _groupRepositoryListener.cancel();
    if (!_controller.isClosed) await _controller.close();
  }
}
