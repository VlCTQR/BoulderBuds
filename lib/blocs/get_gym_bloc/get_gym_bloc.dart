import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gym_repository/gym_repository.dart';

part 'get_gym_event.dart';
part 'get_gym_state.dart';

class GetGymBloc extends Bloc<GetGymEvent, GetGymState> {
  GymRepository _gymRepository;
  GetGymBloc({required GymRepository gymRepository})
      : _gymRepository = gymRepository,
        super(GetGymInitial()) {
    on<GetGyms>((event, emit) async {
      GetGymLoading();
      try {
        List<Gym> gyms = await _gymRepository.getGym();
        emit(GetGymSuccess(gyms));
      } catch (e) {
        emit(GetGymFailure());
      }
    });
  }
}
