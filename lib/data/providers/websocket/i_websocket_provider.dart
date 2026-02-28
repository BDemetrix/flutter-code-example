import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures/failures.dart';

/// Базовый интерфейс WebSocket провайдера
/// Обеспечивает подключение, отправку и получение сообщений
abstract class IWebSocketProvider<TLoginData> {
  /// Подключение к серверу с использованием данных для входа
  Future<Either<Failure, void>> login(TLoginData data);

  /// Отправка сообщения на сервер
  void send(String message);

  /// Поток входящих сообщений
  Stream<Either<Failure, Map<String, dynamic>>> get stream;

  /// Адрес сервера
  String? get serverUri;

  /// Статус подключения
  bool get loggedIn;
}
