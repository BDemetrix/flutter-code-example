import '../abonent/abonent.dart';

/// Базовый класс для payload абонентов
sealed class AbonentPayload {}

/// Список абонентов
class AbonentListPayload extends AbonentPayload {
  final List<Abonent> abonents;
  AbonentListPayload(this.abonents);
}

/// ID абонентов для удаления
class AbonentIdsPayload extends AbonentPayload {
  final List<String> abonentIds;
  AbonentIdsPayload(this.abonentIds);
}
