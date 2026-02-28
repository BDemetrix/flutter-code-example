import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await getIt.init();
}

/// Модуль для регистрации зависимостей
@module
abstract class CoreModule {
  // Здесь можно регистрировать сторонние зависимости
}
