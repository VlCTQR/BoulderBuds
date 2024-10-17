import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc
    extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  final UserRepository _userRepository;

  UpdateUserInfoBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UpdateUserInfoInitial()) {
    on<UploadPicture>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        String userImage =
            await _userRepository.uploadPicture(event.file, event.userId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure());
      }
    });

    on<UploadPictureWeb>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        String userImage =
            await _userRepository.uploadPictureWeb(event.file, event.userId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure());
      }
    });

    on<UpdateUserInfo>((event, emit) async {
      emit(UploadUserDataLoading());
      try {
        _userRepository.setUserData(event.myUser);
        emit(UploadUserDataSuccess(event.myUser));
      } catch (e) {
        emit(UploadUserDataFailure());
      }
    });

    on<AddBuddy>((event, emit) async {
      emit(UploadUserDataLoading());
      try {
        _userRepository.addBuddy(event.myUser, event.buddyId);
        emit(UploadUserDataSuccess(event.myUser));
      } catch (e) {
        emit(UploadUserDataFailure());
      }
    });

    on<AddOutgoingRequest>((event, emit) async {
      emit(UploadUserDataLoading());
      try {
        _userRepository.addOutgoingRequest(event.myUser, event.userToInviteId);
        emit(UploadUserDataSuccess(event.myUser));
      } catch (e) {
        emit(UploadUserDataFailure());
      }
    });

    on<AddIncomingRequest>((event, emit) async {
      emit(UploadUserDataLoading());
      try {
        _userRepository.addIncomingRequest(event.myUser, event.userId);
        emit(UploadUserDataSuccess(event.myUser));
      } catch (e) {
        emit(UploadUserDataFailure());
      }
    });

    on<RemoveBuddy>((event, emit) async {
      emit(UploadUserDataLoading());
      try {
        _userRepository.removeBuddy(event.myUser, event.userId);
        emit(UploadUserDataSuccess(event.myUser));
      } catch (e) {
        emit(UploadUserDataFailure());
      }
    });

    on<RemoveOutgoingRequest>((event, emit) async {
      emit(UploadUserDataLoading());
      try {
        _userRepository.removeOutgoingRequest(event.myUser, event.userId);
        emit(UploadUserDataSuccess(event.myUser));
      } catch (e) {
        emit(UploadUserDataFailure());
      }
    });

    on<RemoveIncomingRequest>((event, emit) async {
      emit(UploadUserDataLoading());
      try {
        _userRepository.removeIncomingRequest(event.myUser, event.userId);
        emit(UploadUserDataSuccess(event.myUser));
      } catch (e) {
        emit(UploadUserDataFailure());
      }
    });

    on<DeleteUser>((event, emit) async {
      emit(DeleteUserLoading());
      try {
        await _userRepository.deleteUser(event.myUser);
        emit(DeleteUserSuccess());
      } catch (e) {
        emit(DeleteUserFailure());
      }
    });
  }
}
