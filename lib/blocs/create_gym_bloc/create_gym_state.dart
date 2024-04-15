part of 'create_gym_bloc.dart';

sealed class CreateGymState extends Equatable {
  const CreateGymState();

  @override
  List<Object> get props => [];
}

final class CreateGymInitial extends CreateGymState {}

final class CreateGymFailure extends CreateGymState {}

final class CreateGymLoading extends CreateGymState {}

final class CreateGymSuccess extends CreateGymState {
  final Gym gym;

  const CreateGymSuccess(this.gym);
}
