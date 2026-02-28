import 'dart:convert';

import '../../domain/entities/group/group.dart';

/// Маппер для преобразования групп в Map/JSON и обратно
class GroupMapper {
  /// Преобразует объект [Group] в Map
  static Map<String, dynamic> toMap(Group group) {
    return {
      'id': group.id,
      'name': group.name,
      'priority': group.priority,
      'emergency': group.emergency,
      'allCall': group.allCall,
      'broadcast': group.broadcast,
    };
  }

  /// Создаёт объект [Group] из Map
  static Group fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as String,
      name: map['name'] as String,
      priority: map['priority'] as int,
      emergency: map['emergency'] as int,
      allCall: map['allCall'] as int,
      broadcast: map['broadcast'] as int,
    );
  }

  /// Преобразует объект [Group] в JSON-строку
  static String toJson(Group group) {
    return jsonEncode(toMap(group));
  }

  /// Создаёт объект [Group] из JSON-строки
  static Group fromJson(String json) {
    return fromMap(jsonDecode(json));
  }
}
