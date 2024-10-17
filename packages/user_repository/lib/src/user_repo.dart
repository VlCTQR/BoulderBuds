import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> deleteUser(MyUser myUser);

  Future<void> resetPassword(String email);

  // setUserData
  Future<MyUser> setUserData(MyUser user);

  Future<MyUser> addBuddy(MyUser user, String buddyId);

  Future<MyUser> addOutgoingRequest(MyUser user, String userToInviteId);

  Future<MyUser> addIncomingRequest(MyUser userToInvite, String userId);

  Future<MyUser> removeBuddy(MyUser user, String buddyIdToDelete);

  Future<MyUser> removeOutgoingRequest(
      MyUser user, String userInvitedIdToDelete);

  Future<MyUser> removeIncomingRequest(
      MyUser userInvited, String userIdToDelete);

  // getMyUser
  Future<MyUser> getMyUser(String myUserId);

  Future<List<MyUser>> getMyUsers();

  Stream<List<MyUser>> getUsersCollectionStream();

  Future<String> uploadPicture(String file, String userId);

  Future<String> uploadPictureWeb(XFile? pickedFile, String userId);
}
