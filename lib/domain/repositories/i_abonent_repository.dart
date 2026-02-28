import 'package:fpdart/fpdart.dart' show Either;

import '../../core/errors/failures/failures.dart';
import '../../domain/entities/abonent/abonent_payload.dart';
import '../../domain/entities/operation/operation_container.dart';

/// Интерфейс репозитория абонентов
abstract class IAbonentRepository {
  /// Поток событий изменений списка абонентов
  Stream<Either<Failure, OperationContainer<AbonentPayload>>> get stream;
}
