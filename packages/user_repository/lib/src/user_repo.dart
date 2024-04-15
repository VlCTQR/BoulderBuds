import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> resetPassword(String email);

  // setUserData
  Future<MyUser> setUserData(MyUser user);

  // getMyUser
  Future<MyUser> getMyUser(String myUserId);

  Future<List<MyUser>> getMyUsers();

  Future<String> uploadPicture(String file, String userId);

  Future<String> uploadPictureWeb(XFile? pickedFile, String userId);
}
