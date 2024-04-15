import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_repository/gym_repository.dart';
import 'package:uuid/uuid.dart';

class FirebaseGymRepository implements GymRepository {
  final gymCollection = FirebaseFirestore.instance.collection('gyms');

  @override
  Future<Gym> createGym(Gym gym) async {
    try {
      gym.gymId = const Uuid().v1();

      await gymCollection.doc(gym.gymId).set(gym.toEntity().toDocument());
      return gym;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Gym>> getGym() {
    try {
      return gymCollection.get().then((value) => value.docs
          .map((e) => Gym.fromEntity(GymEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
