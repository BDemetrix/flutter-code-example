import 'operation.dart';

/// Контейнер для передачи операции и связанных с ней данных.
///
/// Используется в бизнес-слое и не зависит от формата API.
class OperationContainer<T> {
  final Operation operation;
  final T data;

  const OperationContainer({required this.operation, required this.data});
}
