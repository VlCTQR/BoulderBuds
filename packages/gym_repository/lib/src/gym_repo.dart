import 'package:gym_repository/gym_repository.dart';

abstract class GymRepository {
  Future<Gym> createGym(Gym gym);

  Future<List<Gym>> getGym();
}
