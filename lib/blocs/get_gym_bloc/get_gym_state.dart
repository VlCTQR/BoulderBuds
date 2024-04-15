part of 'get_gym_bloc.dart';

sealed class GetGymState extends Equatable {
  const GetGymState();

  @override
  List<Object> get props => [];
}

final class GetGymInitial extends GetGymState {}

final class GetGymFailure extends GetGymState {}

final class GetGymLoading extends GetGymState {}

final class GetGymSuccess extends GetGymState {
  final List<Gym> gyms;

  const GetGymSuccess(this.gyms);
}
