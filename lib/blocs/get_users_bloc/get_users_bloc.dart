import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'get_users_event.dart';
part 'get_users_state.dart';

class GetUsersBloc extends Bloc<GetUsersEvent, GetUsersState> {
  final UserRepository _userRepository;
  GetUsersBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(GetUsersInitial()) {
    on<GetUsers>((event, emit) async {
      emit(GetUsersLoading());
      try {
        List<MyUser> users = await _userRepository.getMyUsers();
        emit(GetUsersSuccess(users));
      } catch (e) {
        emit(GetUsersFailure());
      }
    });
  }
}
