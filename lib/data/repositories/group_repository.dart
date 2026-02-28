import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide Group;

import '../../../core/errors/failures/failures.dart';
import '../../../data/mappers/group_mapper.dart';
import '../../../data/mappers/operation_mapper.dart';
import '../../../data/providers/websocket/i_websocket_provider.dart';
import '../../../data/repositories/base_classes/ws_repository.dart';
import '../../../domain/entities/group/group_payload.dart';
import '../../../domain/entities/operation/operation.dart';
import '../../../domain/entities/operation/operation_container.dart';
import '../../../domain/repositories/i_group_repository.dart';

/// Реализация репозитория групп
/// Получает данные о группах через WebSocket
class GroupRepository extends WsRepository<OperationContainer<GroupPayload>>
    implements IGroupRepository {
  GroupRepository({
    required super.webSocketProvider,
  });

  @override
  void requestGroupList() {
    final request = {"MessageID": "DATAEX", "DataType": 12, "Operation": 0};
    webSocketProvider.send(jsonEncode(request));
  }

  @override
  Stream<Either<Failure, OperationContainer<GroupPayload>>> get stream =>
      controller.stream;

  @override
  @protected
  void onMessage(Either<Failure, Map<String, dynamic>> either) {
    either.fold(
      (failure) => _handleFailure(failure),
      (data) => _handleSuccessData(data),
    );
  }

  void _handleFailure(Failure failure) {
    return;
  }

  void _handleSuccessData(Map<String, dynamic> data) {
    if (data['MessageID'] != 'DATAEX') {
      return;
    }
    if (data['DataType'] != 12 || data['Operation'] != 0) return;

    Operation operation;
    try {
      operation = OperationMapper.fromCode(
        int.parse(data['Operation'].toString()),
      );
    } catch (e, st) {
      return;
    }

    final dataObjects = data['DataObjects'];
    if (dataObjects == null || dataObjects is! List) {
      controller.add(
        Right(
          OperationContainer(
            operation: Operation.add,
            data: GroupListPayload([]),
          ),
        ),
      );
      return;
    }

    try {
      switch (operation) {
        case Operation.initialize:
        case Operation.add:
        case Operation.change:
          final groups = dataObjects
              .map((e) => GroupMapper.fromMap(e as Map<String, dynamic>))
              .toList();
          controller.add(
            Right(
              OperationContainer(
                data: GroupListPayload(groups),
                operation: operation,
              ),
            ),
          );
          break;
        case Operation.remove:
          final List<String> groupIds = [];
          for (var e in dataObjects) {
            final id = (e['id'] ?? '') as String;
            if (id.isNotEmpty) groupIds.add(id);
          }
          controller.add(
            Right(
              OperationContainer(
                data: GroupIdsPayload(groupIds),
                operation: operation,
              ),
            ),
          );
      }
    } catch (e, st) {
      controller.add(Left(ParsingFailure(message: 'Ошибка парсинга')));
    }
  }
}
