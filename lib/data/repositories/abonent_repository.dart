import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures/failures.dart';
import '../../../data/mappers/abonent_mapper.dart';
import '../../../data/mappers/operation_mapper.dart';
import '../../../data/providers/websocket/i_websocket_provider.dart';
import '../../../data/repositories/base_classes/ws_repository.dart';
import '../../../domain/entities/abonent/abonent_payload.dart';
import '../../../domain/entities/operation/operation.dart';
import '../../../domain/entities/operation/operation_container.dart';
import '../../../domain/repositories/i_abonent_repository.dart';

/// Реализация репозитория абонентов
/// Получает данные о абонентах через WebSocket
class AbonentRepository extends WsRepository<OperationContainer<AbonentPayload>>
    implements IAbonentRepository {
  AbonentRepository({
    required super.webSocketProvider,
  });

  @override
  Stream<Either<Failure, OperationContainer<AbonentPayload>>> get stream =>
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
    if (data['DataType'] != 11 || data['Operation'] != 0) return;

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
            data: AbonentListPayload([]),
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
          final abonents = dataObjects
              .map((e) => AbonentMapper.fromMap(e as Map<String, dynamic>))
              .toList();
          controller.add(
            Right(
              OperationContainer(
                data: AbonentListPayload(abonents),
                operation: operation,
              ),
            ),
          );
          break;
        case Operation.remove:
          final List<String> abonentIds = [];
          for (var e in dataObjects) {
            final id = (e['id'] ?? '') as String;
            if (id.isNotEmpty) abonentIds.add(id);
          }
          controller.add(
            Right(
              OperationContainer(
                data: AbonentIdsPayload(abonentIds),
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
