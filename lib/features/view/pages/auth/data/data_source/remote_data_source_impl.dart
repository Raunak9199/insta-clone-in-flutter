import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socio_chat/features/view/pages/auth/data/data_source/remote_data_source_interface.dart';

import 'package:socio_chat/features/view/pages/auth/data/models/user_model.dart';

import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';

class FirebRemoteDataSourceImplementation
    implements FirebRemoteDataSourceInterface {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage storage;

  FirebRemoteDataSourceImplementation({
    required this.firestore,
    required this.firebaseAuth,
    required this.storage,
  });

  Future<void> addDataToFirebase(UserEntity user, String profUrl) async {
    // Get the snapshot of users form users collection
    final snap = firestore.collection("users");
    //Get the current user uid
    final uid = await fetchLoggedInUserUid();
    //
    snap.doc(uid).get().then((userData) {
      // Map the values to the model to create a new user
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
        about: user.about,
        friends: user.friends,
        profileUrl: profUrl,
        userName: user.userName,
        totalConnections: user.totalConnections,
        connections: user.connections,
        totalFriends: user.totalFriends,
        totalPosts: user.totalPosts ?? 0,
      ).toDocument();
      if (userData.exists) {
        snap.doc(uid).update(newUser);
      } else {
        snap.doc(uid).set(newUser, SetOptions(merge: true));
      }
    }).catchError((error) {
      // If error occurs show a toast
      NewAppSnackBar.showSnackbar(msg: "$error");
      log("$error");
    });
  }

  @override
  Stream<List<UserEntity>> fetchTotalUsersFromFirebase(UserEntity user) {
    final userSnapshot = firestore.collection("users");

    return userSnapshot.snapshots().map((querySnap) =>
        querySnap.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> implementLoggedInUserData(UserEntity user) async {
    // Get the collection of users
    final collection = firestore.collection("users");
    //Get the current user uid
    final uid = await fetchLoggedInUserUid();
    collection.doc(uid).get().then((value) {
      final newUserData = UserModel(
        about: user.about,
        connections: user.connections,
        email: user.email,
        friends: user.friends,
        uid: uid,
        name: user.name,
        profileUrl: user.profileUrl,
        totalConnections: user.totalConnections,
        totalFriends: user.totalFriends,
        totalPosts: user.totalPosts ?? 0,
        userName: user.userName,
      ).toDocument();

      if (!value.exists) {
        collection.doc(uid).set(newUserData);
      } else {
        collection.doc(uid).update(newUserData);
      }
    }).catchError((err) {
      NewAppSnackBar.showSnackbar(msg: "$err");
      log("$err");
    });
  }

  @override
  Future<String> fetchLoggedInUserUid() async => firebaseAuth.currentUser!.uid;

// Single user
  @override
  Stream<List<UserEntity>> fetchLoggedInUserData(String uid) {
    // Get the snapshot of currently loggedin user by matching uid from firebase
    final userSnapshot =
        firestore.collection("users").where("uid", isEqualTo: uid).limit(1);
    // Map the fetched data to usermodel, convert to list and return it to display the user data.
    return userSnapshot.snapshots().map(
          (querySnap) =>
              querySnap.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
        );
  }

// Check if any user is signed in or not.
  @override
  Future<bool> isSignedIn() async => firebaseAuth.currentUser?.uid != null;
// Method to signin user to firebase from the app
  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
    } on FirebaseAuthException catch (e) {
      // If error occurs, check for the type oferror. Like-
      // If user entered wrong password
      if (e.code == "wrong-password") {
        NewAppSnackBar.showSnackbar(
          msg: "Please enter a correct email or password",
        );
      } else if (e.code == "user-not-found") {
        // If User haven't registered yet
        NewAppSnackBar.showSnackbar(
          msg: "User not found.",
        );
      } else if (user.email!.isEmpty || user.password!.isEmpty) {
        // If user provided an empty email or password
        NewAppSnackBar.showSnackbar(
          msg: "Please fill all the credentials.",
        );
      } else {
        // Rest of the errors will be displayed in here
        NewAppSnackBar.showSnackbar(
          msg: "$e",
        );
      }
    }
  }

// To logout from the application
  @override
  Future<void> logoutUserFromFirebase() async => await firebaseAuth.signOut();

  // Register user to th app
  @override
  Future<void> registerUserToFirebase(UserEntity user) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      )
          .then((value) async {
        // Chech if user is created
        if (value.user?.uid != null) {
          // Chech if image file is not null then store profile image into firebase database
          if (user.imgFile != null) {
            storeImage(
              user.imgFile, // Image file provided by the user
              "profImages",

              // const Uuid().v1(), // Random Id to store image on that id
            ).then((profileUrl) {
              addDataToFirebase(user, profileUrl);
            });
          } else {
            // If user is created and no profile image was provided, create user with no profile
            addDataToFirebase(user, "");
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      // Error handling like -
      // If email is already in use show a toast message
      if (e.code == "email-already-in-use") {
        NewAppSnackBar.showSnackbar(msg: "This email is already in use.");
      } else {
        NewAppSnackBar.showSnackbar(msg: "$e.");
      }
    }
  }

  // To update the current user profile image
  @override
  Future<void> updateUserProfImg(UserEntity user) async {
    final snapshot = firestore.collection("users");
    Map<String, dynamic> userDetailsSnap = {};
    if (user.profileUrl != "" || user.profileUrl != null) {
      userDetailsSnap['profileUrl'] = user.profileUrl;
    }
    snapshot.doc(user.uid).update(userDetailsSnap);
  }

// To fetch other users from the firebase database except the current user
  @override
  Stream<List<UserEntity>> fetchEveryOtherUser(String otherId) {
    final userSnapshot = firestore
        .collection("users")
        .where(
          "uid",
          isEqualTo: otherId,
        )
        .limit(1);
    return userSnapshot.snapshots().map(
          (querySnap) =>
              querySnap.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  Future<void> refreshUserData(UserEntity userData, PostEntity post) async {
    final userSnapshot = firestore.collection("users");
    // final userPostSnapshot = firestore.collection("posts");
    Map<String, dynamic> userSnapshotDetails = {};
    Map<String, dynamic> userPostSnapshotDetails = {};

    // Check if username is not empty and not null
    try {
      if (userData.userName != null && userData.userName!.isNotEmpty) {
        userSnapshotDetails['userName'] = userData.userName;
        userPostSnapshotDetails['userName'] = userData.userName;
      }

      // Check if name is not empty and not null
      if (userData.name != null && userData.name!.isNotEmpty) {
        userSnapshotDetails['name'] = userData.name;
      }

      // Check if description about user is not empty and not null
      if (userData.about != null && userData.about!.isNotEmpty) {
        userSnapshotDetails['about'] = userData.about;
      }

      // Update the data to the useruid
      await userSnapshot.doc(userData.uid).update(userSnapshotDetails);
    } catch (e) {
      NewAppSnackBar.showSnackbar(msg: "$e.");
    }
  }

  @override
  Future<String> storeImage(File? imageFile, String fileName) async {
    final currentUser = firebaseAuth.currentUser!.uid;

    // Get the reference of the storage of path of the current user
    Reference imageReference = storage.ref().child(fileName).child(currentUser);

    final imageUpload = imageReference.putFile(imageFile!);
    // Get the imageurl after the upload is complete to show the image when needed.
    final imageUrl =
        (await imageUpload.whenComplete(() {})).ref.getDownloadURL();
    return await imageUrl;
  }

// To store the post images
  @override
  Future<String> storePost(
    File? imageFile,
    String fileName,
    String randomId,
  ) async {
    final currentUser = firebaseAuth.currentUser!.uid;
    // Get the reference of the storage of path of the current user
    Reference imageReference = storage.ref().child(fileName).child(currentUser);

    // To obtain the random id and store the user's post on that id
    imageReference = imageReference.child(randomId);

    final imageUpload = imageReference.putFile(imageFile!);
    // Get the imageurl after the upload is complete to show the image when needed.
    final imageUrl =
        (await imageUpload.whenComplete(() {})).ref.getDownloadURL();
    return await imageUrl;
  }

  @override
  Future<void> followUser(UserEntity user) async {
    final usersCollection = FirebaseFirestore.instance.collection("users");

    final myDocumentSnapshot = await usersCollection.doc(user.uid).get();
    final otherUserDocumentSnapshot =
        await usersCollection.doc(user.otherId).get();

    try {
      if (myDocumentSnapshot.exists && otherUserDocumentSnapshot.exists) {
        List myFriendsList = myDocumentSnapshot.get("friends");
        List otherUserConnectionsList =
            otherUserDocumentSnapshot.get("connections");

        // My friends
        if (myFriendsList.contains(user.otherId)) {
          await usersCollection.doc(user.uid).update({
            "friends": FieldValue.arrayRemove([user.otherId])
          });

          final myUserSnapshot = await usersCollection.doc(user.uid).get();
          if (myUserSnapshot.exists) {
            final totalFriends = myUserSnapshot.get('totalFriends');
            await usersCollection
                .doc(user.uid)
                .update({"totalFriends": totalFriends - 1});
          }
        } else {
          await usersCollection.doc(user.uid).update({
            "friends": FieldValue.arrayUnion([user.otherId])
          });

          final myUserSnapshot = await usersCollection.doc(user.uid).get();
          if (myUserSnapshot.exists) {
            final totalFriends = myUserSnapshot.get('totalFriends');
            await usersCollection
                .doc(user.uid)
                .update({"totalFriends": totalFriends + 1});
          }
        }

        // Other User friends
        if (otherUserConnectionsList.contains(user.uid)) {
          await usersCollection.doc(user.otherId).update({
            "connections": FieldValue.arrayRemove([user.uid])
          });

          final otherUserSnapshot =
              await usersCollection.doc(user.otherId).get();
          if (otherUserSnapshot.exists) {
            final totalConnections = otherUserSnapshot.get('totalConnections');
            await usersCollection
                .doc(user.otherId)
                .update({"totalConnections": totalConnections - 1});
          }
        } else {
          await usersCollection.doc(user.otherId).update({
            "connections": FieldValue.arrayUnion([user.uid])
          });

          final otherUserSnapshot =
              await usersCollection.doc(user.otherId).get();
          if (otherUserSnapshot.exists) {
            final totalConnections = otherUserSnapshot.get('totalConnections');
            await usersCollection
                .doc(user.otherId)
                .update({"totalConnections": totalConnections + 1});
          }
        }
      }
    } catch (e) {
      NewAppSnackBar.showSnackbar(msg: "$e.");
    }
  }
/*
 
  @override
  Future<void> downloadPostImage(PostEntity post, String imageName,
      void Function(double) onProgress) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        return;
      }
    }
    final Directory? appDocDir = await getExternalStorageDirectory();
    // final Directory? appDir = await get();
    log(appDocDir!.path);
    final File downloadToFile = File('${appDocDir.path}/$imageName.jpg');
    log("FilePath:=> ${downloadToFile.path}");
    try {
      final urlPattern = RegExp(r'posts/(.+)');
      // final urlPattern = RegExp(
      //     r'https://firebasestorage.googleapis.com/v0/b/[^/]+/o/(.+)\?alt=media.*');
      final match = urlPattern.firstMatch(post.postUrl!);
      if (match != null && match.groupCount >= 1) {
        // store on post id then todo
        final path = Uri.decodeFull(match.group(1)!);
        final DownloadTask task =
            storage.ref().child(path).writeToFile(downloadToFile);
        log(post.postUrl.toString());

        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          // Calculate the progress percentage
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
        await task;
      }

      log('Download complete.');
    } catch (e) {
      log('Failed to download file: $e');
    }
  } */
}
