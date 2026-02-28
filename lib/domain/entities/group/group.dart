/// Сущность группы
class Group {
  final String id;
  final String name;
  final int priority;
  final int emergency;
  final int allCall;
  final int broadcast;

  const Group({
    required this.id,
    required this.name,
    required this.priority,
    required this.emergency,
    required this.allCall,
    required this.broadcast,
  });

  Group copyWith({
    String? id,
    String? name,
    int? priority,
    int? emergency,
    int? allCall,
    int? broadcast,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      emergency: emergency ?? this.emergency,
      allCall: allCall ?? this.allCall,
      broadcast: broadcast ?? this.broadcast,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          priority == other.priority &&
          emergency == other.emergency &&
          allCall == other.allCall &&
          broadcast == other.broadcast;

  @override
  int get hashCode => Object.hash(id, name, priority, emergency, allCall, broadcast);
}
