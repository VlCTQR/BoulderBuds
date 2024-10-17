import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'user_repo.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  StreamSubscription<QuerySnapshot>? _userCollectionSubscription;

  FirebaseUserRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Start listening to Firestore updates for the users collection
  void startListeningToUsersCollection() {
    _userCollectionSubscription =
        usersCollection.snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          log("User added: ${change.doc.id}");
        } else if (change.type == DocumentChangeType.modified) {
          log("User modified: ${change.doc.id}");
        } else if (change.type == DocumentChangeType.removed) {
          log("User removed: ${change.doc.id}");
        }
      }
      // Here you can notify listeners or update the local state if needed
    });
  }

  // Stop listening to updates
  void stopListeningToUsersCollection() {
    _userCollectionSubscription?.cancel();
    log("Stopped listening to users collection.");
  }

  @override
  Stream<List<MyUser>> getUsersCollectionStream() {
    return usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MyUser.fromEntity(
            MyUserEntity.fromDocument(doc.data() as Map<String, dynamic>));
      }).toList();
    });
  }

  // Stream of [MyUser] which will emit the current user when
  // the authentication state changes.
  //
  // Emits [MyUser.empty] if the user is not authenticated.
  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  @override
  Future<List<MyUser>> getMyUsers() async {
    try {
      QuerySnapshot snapshot = await usersCollection.get();
      return snapshot.docs
          .map((doc) => MyUser.fromEntity(
              MyUserEntity.fromDocument(doc.data() as Map<String, dynamic>)))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );

      myUser = myUser.copyWith(id: user.user!.uid);

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(MyUser myUser) async {
    try {
      User? user = await _firebaseAuth.currentUser;
      await user?.delete();

      log("User ${myUser.id} successfully deleted.");
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> setUserData(MyUser user) async {
    try {
      await usersCollection.doc(user.id).set(user.toEntity().toDocument());
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> addBuddy(MyUser user, String buddyId) async {
    try {
      await usersCollection.doc(user.id).update({
        'buddies': FieldValue.arrayUnion([buddyId])
      });
      DocumentSnapshot updatedUserSnapshot =
          await usersCollection.doc(user.id).get();
      MyUser updatedUser = MyUser.fromSnapshot(updatedUserSnapshot);
      return updatedUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> addOutgoingRequest(MyUser user, String userToInviteId) async {
    try {
      await usersCollection.doc(user.id).update({
        'outgoing': FieldValue.arrayUnion([userToInviteId])
      });
      DocumentSnapshot updatedUserSnapshot =
          await usersCollection.doc(user.id).get();
      MyUser updatedUser = MyUser.fromSnapshot(updatedUserSnapshot);
      return updatedUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> addIncomingRequest(MyUser user, String userId) async {
    try {
      await usersCollection.doc(user.id).update({
        'incoming': FieldValue.arrayUnion([userId])
      });
      DocumentSnapshot updatedUserSnapshot =
          await usersCollection.doc(user.id).get();
      MyUser updatedUser = MyUser.fromSnapshot(updatedUserSnapshot);
      return updatedUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> removeBuddy(MyUser user, String buddyIdToDelete) async {
    try {
      await usersCollection.doc(user.id).update({
        'buddies': FieldValue.arrayRemove([buddyIdToDelete])
      });
      DocumentSnapshot updatedUserSnapshot =
          await usersCollection.doc(user.id).get();
      MyUser updatedUser = MyUser.fromSnapshot(updatedUserSnapshot);

      return updatedUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> removeOutgoingRequest(
      MyUser user, String userIdToDelete) async {
    try {
      await usersCollection.doc(user.id).update({
        'outgoing': FieldValue.arrayRemove([userIdToDelete])
      });
      DocumentSnapshot updatedUserSnapshot =
          await usersCollection.doc(user.id).get();
      MyUser updatedUser = MyUser.fromSnapshot(updatedUserSnapshot);

      return updatedUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> removeIncomingRequest(
      MyUser userInvited, String userIdToDelete) async {
    try {
      await usersCollection.doc(userInvited.id).update({
        'incoming': FieldValue.arrayRemove([userIdToDelete])
      });
      DocumentSnapshot updatedUserSnapshot =
          await usersCollection.doc(userInvited.id).get();
      MyUser updatedUser = MyUser.fromSnapshot(updatedUserSnapshot);

      return updatedUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> getMyUser(String myUserId) async {
    try {
      return usersCollection.doc(myUserId).get().then((value) =>
          MyUser.fromEntity(
              MyUserEntity.fromDocument(value.data() as Map<String, dynamic>)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadPicture(String file, String userId) async {
    try {
      File imageFile = File(file);
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(
        imageFile,
      );
      String url = await firebaseStoreRef.getDownloadURL();
      await usersCollection.doc(userId).update({'picture': url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadPictureWeb(XFile? pickedFile, String userId) async {
    try {
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putData(
        await pickedFile!.readAsBytes(),
      );
      String url = await firebaseStoreRef.getDownloadURL();
      await usersCollection.doc(userId).update({'picture': url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
