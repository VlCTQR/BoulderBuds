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

class AddBuddy extends UpdateUserInfoEvent {
  final MyUser myUser;
  final String buddyId;

  const AddBuddy(this.myUser, this.buddyId);

  @override
  List<Object> get props => [myUser, buddyId];
}

class AddOutgoingRequest extends UpdateUserInfoEvent {
  final MyUser myUser;
  final String userToInviteId;

  const AddOutgoingRequest(this.myUser, this.userToInviteId);

  @override
  List<Object> get props => [myUser, userToInviteId];
}

class AddIncomingRequest extends UpdateUserInfoEvent {
  final MyUser myUser;
  final String userId;

  const AddIncomingRequest(this.myUser, this.userId);

  @override
  List<Object> get props => [myUser, userId];
}

class RemoveBuddy extends UpdateUserInfoEvent {
  final MyUser myUser;
  final String userId;

  const RemoveBuddy(this.myUser, this.userId);

  @override
  List<Object> get props => [myUser, userId];
}

class RemoveOutgoingRequest extends UpdateUserInfoEvent {
  final MyUser myUser;
  final String userId;

  const RemoveOutgoingRequest(this.myUser, this.userId);

  @override
  List<Object> get props => [myUser, userId];
}

class RemoveIncomingRequest extends UpdateUserInfoEvent {
  final MyUser myUser;
  final String userId;

  const RemoveIncomingRequest(this.myUser, this.userId);

  @override
  List<Object> get props => [myUser, userId];
}

class DeleteUser extends UpdateUserInfoEvent {
  final MyUser myUser;

  const DeleteUser(this.myUser);

  @override
  List<Object> get props => [myUser];
}
