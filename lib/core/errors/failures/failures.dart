import 'package:equatable/equatable.dart';

/// Базовый класс для ошибок
abstract class Failure extends Equatable {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);

  @override
  String toString() => 'Failure: $message \n ${stackTrace ?? ""}';

  @override
  List<Object?> get props => [message, stackTrace];
}

/// Ошибка базы данных
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.stackTrace]);
}

/// Ошибка сервера
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ошибка сервера', super.stackTrace]);
}

/// Ошибка WebSocket
class WebSocketFailure extends Failure {
  const WebSocketFailure({
    String message = 'Ошибка Websocket',
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}

/// Ошибка сети
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Ошибка сети', StackTrace? stackTrace})
    : super(message, stackTrace);
}

/// Ошибка обработки данных
class DataProcessingFailure extends Failure {
  const DataProcessingFailure({
    String message = 'Сбой в обработке данных',
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}

/// Ошибка парсинга
class ParsingFailure extends Failure {
  const ParsingFailure({
    String message = 'Сбой в парсинге данных',
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}

/// Ошибка аргумента
class ArgumentFailure extends Failure {
  const ArgumentFailure({
    String message = 'Сбой в обработке данных',
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}

/// Ошибка таймаута
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Истечение времени завершения операции',
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}

/// Неизвестная ошибка
class UnknownFailure extends Failure {
  const UnknownFailure(String message, [StackTrace? stackTrace])
    : super('Неизвестная ошибка: $message', stackTrace);
}
