part of 'create_gym_bloc.dart';

sealed class CreateGymEvent extends Equatable {
  const CreateGymEvent();

  @override
  List<Object> get props => [];
}

class CreateGym extends CreateGymEvent {
  final Gym gym;

  const CreateGym(this.gym);
}
