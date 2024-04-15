part of 'get_users_bloc.dart';

sealed class GetUsersState extends Equatable {
  const GetUsersState();

  @override
  List<Object> get props => [];
}

final class GetUsersInitial extends GetUsersState {}

final class GetUsersFailure extends GetUsersState {}

final class GetUsersLoading extends GetUsersState {}

final class GetUsersSuccess extends GetUsersState {
  final List<MyUser> users;

  const GetUsersSuccess(this.users);
}
