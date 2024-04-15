part of 'get_gym_bloc.dart';

sealed class GetGymEvent extends Equatable {
  const GetGymEvent();

  @override
  List<Object> get props => [];
}

class GetGyms extends GetGymEvent {}
