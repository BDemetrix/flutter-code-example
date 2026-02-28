# Пример архитектуры отображения контактов (абоненты и группы)

Данный пример демонстрирует архитектуру приложения для отображения списка абонентов и групп с использованием Flutter и Clean Architecture.

## Структура проекта

```
example-contacts/
├── lib/
│   ├── core/                        # Ядро приложения
│   │   ├── di/                      # Dependency Injection
│   │   │   ├── injection.dart       # Настройка get_it + injectable
│   │   │   ├── injection.g.dart     # Автогенерируемая конфигурация
│   │   │   └── launching.dart       # Точка входа для инициализации
│   │   ├── errors/
│   │   │   └── failures/
│   │   │       └── failures.dart    # Базовые классы ошибок
│   │   └── routes/
│   │       └── router.dart          # Маршрутизация через go_router
│   ├── data/                        # Слой данных
│   │   ├── mappers/                 # Мапперы для преобразования данных
│   │   │   ├── abonent_mapper.dart
│   │   │   └── group_mapper.dart
│   │   ├── providers/
│   │   │   └── websocket/
│   │   │       └── i_websocket_provider.dart
│   │   └── repositories/
│   │       ├── base_classes/
│   │       │   └── ws_repository.dart    # Базовый класс репозитория
│   │       ├── abonent_repository.dart   # Реализация репозитория абонентов
│   │       └── group_repository.dart     # Реализация репозитория групп
│   ├── domain/                      # Доменный слой (бизнес-логика)
│   │   ├── aggregates/
│   │   │   └── contacts/
│   │   │       ├── contacts_aggregate.dart    # Агрегат контактов
│   │   │       └── search_contacts_usecase.dart
│   │   ├── entities/
│   │   │   ├── abonent/
│   │   │   │   ├── abonent.dart
│   │   │   │   └── abonent_payload.dart
│   │   │   ├── group/
│   │   │   │   ├── group.dart
│   │   │   │   └── group_payload.dart
│   │   │   └── operation/
│   │   │       ├── operation.dart
│   │   │       └── operation_container.dart
│   │   └── repositories/
│   │       ├── i_abonent_repository.dart
│   │       └── i_group_repository.dart
│   └── presentation/                # Слой представления (UI)
│       ├── bloc/
│       │   └── contacts/
│       │       └── contacts_cubit.dart
│       ├── pages/
│       │   └── contacts/
│       │       ├── contacts_page.dart
│       │       └── contacts_view.dart
│       └── widgets/
│           └── contacts/
│               ├── abonent_item.dart
│               └── group_item.dart
├── test/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## Архитектурные слои

### Core Layer (Ядро)
- **DI** - внедрение зависимостей через `get_it` + `injectable`
- **Errors/Failures** - базовые классы для обработки ошибок
- **Routes** - маршрутизация через `go_router`

### Data Layer (Слой данных)
- **IWebSocketProvider** - интерфейс для WebSocket соединения
- **WsRepository** - базовый класс для всех WebSocket репозиториев с `Talker` для логирования
- **AbonentRepository** - репозиторий для работы с данными абонентов
- **GroupRepository** - репозиторий для работы с данными групп
- **Mappers** - преобразование между JSON и сущностями

### Domain Layer (Бизнес-логика)
- **Entities** - чистые сущности предметной области:
  - `Abonent` - абонент с полями id, name, login, deviceId, isOnline, hasInCall
  - `Group` - группа с полями id, name, priority, emergency, allCall, broadcast
  - `Operation` - типы операций (initialize, add, change, remove)
  - `OperationContainer<T>` - контейнер для операций с данными
- **Repositories** - интерфейсы репозиториев (контракты)
- **Aggregates** - агрегаты, объединяющие данные из нескольких источников:
  - `ContactsAggregate` - объединяет потоки данных абонентов и групп
- **UseCases** - бизнес-правила:
  - `SearchContactsUseCase` - поиск по имени, логину, названию группы

### Presentation Layer (UI)
- **Cubit** - управление состоянием экрана через `ValueNotifier`
- **Pages** - страницы приложения (`ContactsPage`)
- **Widgets** - переиспользуемые компоненты UI:
  - `ContactsView` - основной виджет списка с табами
  - `AbonentItem` - карточка абонента с индикатором онлайн-статуса
  - `GroupItem` - карточка группы
  - `GroupsSection`, `AbonentsSection` - секции с табами

## Основные возможности

1. **Отображение списка абонентов** с разделением на онлайн/оффлайн
2. **Отображение списка групп**
3. **Поиск** по имени абонента, логину и названию группы
4. **Tab-based навигация** между группами и абонентами
5. **Индикация онлайн-статуса** (зеленый/серый кружок)
6. **Pull-to-refresh** для обновления данных
7. **Логирование** через `Talker` для отладки

## Зависимости

### Основные
- `flutter` (SDK)
- `fpdart` - функциональные типы `Either` для обработки ошибок
- `talker_flutter` - логирование и отладка
- `get_it` - dependency injection
- `injectable` - автогенерация DI
- `go_router` - декларативная маршрутизация

### Для разработки
- `injectable_generator` - генерация кода для DI
- `build_runner` - запуск генераторов кода
- `go_router_builder` - генерация маршрутов

## Установка и запуск

```bash
# Перейти в директорию примера
cd example-contacts

# Установить зависимости
flutter pub get

# Запустить генерацию кода (для injectable)
dart run build_runner build --delete-conflicting-outputs

# Запустить приложение
flutter run
```

## Использование

```dart
import 'package:example_contacts/core/di/launching.dart';
import 'package:example_contacts/core/routes/router.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация зависимостей
  await bootstrap();
  
  runApp(
    MaterialApp.router(
      title: 'Контакты',
      routerConfig: AppRouter.router,
    ),
  );
}
```

## Архитектурные особенности

### Поток данных
1. WebSocket → `IWebSocketProvider` → `WsRepository` → `IAbonentRepository`/`IGroupRepository`
2. Репозитории → `ContactsAggregate` (объединяет потоки) → `ContactsCubit` → UI
3. Поиск → `SearchContactsUseCase` → фильтрация в Cubit → UI

### Обработка ошибок
- Все ошибки передаются через `Either<Failure, T>` из `fpdart`
- Базовый класс `Failure` с сообщением и `StackTrace`
- Специфичные ошибки: `WebSocketFailure`, `NetworkFailure`, `ParsingFailure`, `DataProcessingFailure`

### Логирование
- `Talker` используется во всех слоях для логирования
- Наследники `WsRepository` получают `Talker` через конструктор
- Ошибки логируются с `StackTrace` для отладки

## Примечания

- Пример включает заглушку `ExampleWebSocketProvider` для демонстрации
- Геолокация и меню с выходом исключены из примера
- Все упоминания WalkieFleet удалены
- PTT (Push-to-Talk) функционал упрощен (убрана анимация)
- Для полноценной работы требуется реализовать реальный WebSocket провайдер

## Расширение

Для добавления новых функций:
1. Создайте entity в `domain/entities/`
2. Создайте repository interface в `domain/repositories/`
3. Реализуйте repository в `data/repositories/` через наследование от `WsRepository`
4. Добавьте aggregate в `domain/aggregates/` если нужно объединить данные
5. Создайте use case в `domain/aggregates/` для бизнес-логики
6. Обновите cubit и UI в `presentation/`
