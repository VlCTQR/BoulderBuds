part of 'get_users_bloc.dart';

sealed class GetUsersEvent extends Equatable {
  const GetUsersEvent();

  @override
  List<Object> get props => [];
}

class GetUsers extends GetUsersEvent {}
