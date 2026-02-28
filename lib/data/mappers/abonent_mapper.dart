import 'dart:convert';

import '../../domain/entities/abonent/abonent.dart';

/// Маппер для преобразования абонентов в Map и обратно
class AbonentMapper {
  static Map<String, dynamic> toMap(Abonent abonent) {
    return {
      'id': abonent.id,
      'name': abonent.name,
      'login': abonent.login,
      'isOnline': abonent.isOnline,
    };
  }

  static Abonent fromMap(Map<String, dynamic> map) {
    return Abonent(
      id: map['id'] as String,
      name: map['name'] as String,
      login: map['login'] as String,
      isOnline: map['isOnline'] as bool? ?? false,
    );
  }

  static String toJson(Abonent abonent) {
    return jsonEncode(toMap(abonent));
  }

  static Abonent fromJson(String json) {
    return fromMap(jsonDecode(json));
  }
}
