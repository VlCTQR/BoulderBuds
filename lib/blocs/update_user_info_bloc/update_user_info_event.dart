part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UploadPicture extends UpdateUserInfoEvent {
  final String file;
  final String userId;

  const UploadPicture(this.file, this.userId);

  @override
  List<Object> get props => [file, userId];
}

class UploadPictureWeb extends UpdateUserInfoEvent {
  final XFile file;
  final String userId;

  const UploadPictureWeb(this.file, this.userId);

  @override
  List<Object> get props => [file, userId];
}

class UpdateUserInfo extends UpdateUserInfoEvent {
  final MyUser myUser;

  const UpdateUserInfo(this.myUser);

  @override
  List<Object> get props => [myUser];
}

class DeleteUser extends UpdateUserInfoEvent {
  final MyUser myUser;

  const DeleteUser(this.myUser);

  @override
  List<Object> get props => [myUser];
}
