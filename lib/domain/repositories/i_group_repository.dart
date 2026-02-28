import 'package:fpdart/fpdart.dart' hide Group;

import '../../core/errors/failures/failures.dart';
import '../../domain/entities/group/group_payload.dart';
import '../../domain/entities/operation/operation_container.dart';

/// Интерфейс репозитория групп
abstract class IGroupRepository {
  /// Запрос списка групп
  void requestGroupList();

  /// Поток событий изменений списка групп
  Stream<Either<Failure, OperationContainer<GroupPayload>>> get stream;
}
