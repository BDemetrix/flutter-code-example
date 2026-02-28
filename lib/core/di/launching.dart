import 'package:flutter/widgets.dart';

import 'injection.dart';

/// Инициализация зависимостей перед запуском приложения
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
}
