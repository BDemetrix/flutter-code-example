/// Сущность абонента
class Abonent {
  final String id;
  final String name;
  final String login;
  final String deviceId;
  final bool isOnline;
  final bool hasInCall;

  const Abonent({
    required this.id,
    required this.name,
    required this.login,
    this.deviceId = '',
    this.isOnline = false,
    this.hasInCall = false,
  });

  Abonent copyWith({
    String? id,
    String? name,
    String? login,
    String? deviceId,
    bool? isOnline,
    bool? hasInCall,
  }) {
    return Abonent(
      id: id ?? this.id,
      name: name ?? this.name,
      login: login ?? this.login,
      deviceId: deviceId ?? this.deviceId,
      isOnline: isOnline ?? this.isOnline,
      hasInCall: hasInCall ?? this.hasInCall,
    );
  }

  @override
  String toString() {
    return 'Abonent(id: $id, name: $name, login: $login, deviceId: $deviceId, isOnline: $isOnline, hasInCall: $hasInCall)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Abonent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          login == other.login &&
          deviceId == other.deviceId &&
          isOnline == other.isOnline &&
          hasInCall == other.hasInCall;

  @override
  int get hashCode => Object.hash(id, name, login, deviceId, isOnline, hasInCall);
}
