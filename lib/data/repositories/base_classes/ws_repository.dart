import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures/failures.dart';
import '../../../data/providers/websocket/i_websocket_provider.dart';

/// Базовый класс для WebSocket репозиториев
/// Управляет подпиской на WebSocket и предоставляет общий функционал
abstract class WsRepository<StreamData> {
  final IWebSocketProvider _webSocketProvider;
  late StreamController<Either<Failure, StreamData>> _controller;
  StreamSubscription? _webSocketSubscription;

  WsRepository({
    required IWebSocketProvider webSocketProvider,
    dynamic talker, // Для совместимости с оригиналом
  }) : _webSocketProvider = webSocketProvider {
    _controller = StreamController<Either<Failure, StreamData>>.broadcast();
    _webSocketSubscription = _webSocketProvider.stream.listen(
      onMessage,
      onError: _onWebSocketError,
      onDone: _onWebSocketDone,
    );
  }

  // Защищенные геттеры для наследников
  @protected
  IWebSocketProvider get webSocketProvider => _webSocketProvider;

  @protected
  StreamController<Either<Failure, StreamData>> get controller => _controller;

  // Абстрактный метод, который должны реализовать наследники
  @protected
  void onMessage(Either<Failure, Map<String, dynamic>> message);

  // Обработка ошибок WebSocket
  void _onWebSocketError(dynamic error) {
    // Логирование ошибки
  }

  void _onWebSocketDone() {
    _cleanUp();
  }

  void _cleanUp() {
    _webSocketSubscription?.cancel();
    if (!_controller.isClosed) {
      _controller.close();
    }
  }

  void dispose() {
    _cleanUp();
  }
}
