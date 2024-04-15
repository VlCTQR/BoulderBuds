import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gym_repository/gym_repository.dart';

part 'create_gym_event.dart';
part 'create_gym_state.dart';

class CreateGymBloc extends Bloc<CreateGymEvent, CreateGymState> {
  GymRepository _gymRepository;
  CreateGymBloc({required GymRepository gymRepository})
      : _gymRepository = gymRepository,
        super(CreateGymInitial()) {
    on<CreateGym>((event, emit) async {
      emit(CreateGymLoading());
      try {
        Gym gym = await _gymRepository.createGym(event.gym);
        emit(CreateGymSuccess(gym));
      } catch (e) {
        emit(CreateGymFailure());
      }
    });
  }
}
