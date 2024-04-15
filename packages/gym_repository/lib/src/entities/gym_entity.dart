import 'package:gym_repository/gym_repository.dart';
import 'package:equatable/equatable.dart';

class GymEntity extends Equatable {
  final String gymId;
  final String name;

  const GymEntity({
    required this.gymId,
    required this.name,
  });

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'gymId': gymId,
    };
  }

  static GymEntity fromDocument(Map<String, dynamic> doc) {
    return GymEntity(
      gymId: doc['gymId'] as String,
      name: doc['name'] as String,
    );
  }

  @override
  List<Object?> get props => [
        gymId,
        name,
      ];

  @override
  String toString() {
    return '''UserEntity {
      gymId: $gymId
      name: $name
    }''';
  }
}
