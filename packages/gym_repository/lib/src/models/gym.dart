import 'package:gym_repository/gym_repository.dart';
import 'package:equatable/equatable.dart';

class Gym extends Equatable {
  String gymId;
  String name;

  Gym({
    required this.gymId,
    required this.name,
  });

  // Emtpy Gym
  static final empty = Gym(
    gymId: '',
    name: '',
  );

  // Modify Gym fields
  Gym copyWith({
    String? name,
    String? gymId,
  }) {
    return Gym(
      name: name ?? this.name,
      gymId: gymId ?? this.gymId,
    );
  }

  bool get isEmpty => this == Gym.empty;

  bool get isNotEmpyt => this != Gym.empty;

  GymEntity toEntity() {
    return GymEntity(
      name: name,
      gymId: gymId,
    );
  }

  static Gym fromEntity(GymEntity entity) {
    return Gym(
      name: entity.name,
      gymId: entity.gymId,
    );
  }

  @override
  List<Object?> get props => [
        name,
        gymId,
      ];
}
