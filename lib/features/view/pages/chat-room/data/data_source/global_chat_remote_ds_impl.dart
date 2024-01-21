import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/data/data_source/global_chat_remote_ds_interface.dart';
import 'package:socio_chat/features/view/pages/chat-room/data/models/msg_model.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';

class GlobalChatRemoteDataSourceImpl
    implements GlobalChatRemoteDataSourceInterface {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage storage;

  GlobalChatRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
    required this.storage,
  });

  final String globalChatRoomChannelId = "3Xs7D0iYbBhvDHoiVcAN";

  final String globalCHatCollectionName = "globalChatRoom";
  // Get the stream of chats to display to the users
  @override
  Stream<List<GlobalChatEntity>> getMessages() {
    // Get the snapshot of the global chat ordered by time
    final globalChatRoomSnapshot = firestore
        .collection(globalCHatCollectionName)
        .doc(globalChatRoomChannelId)
        .collection("messages")
        .orderBy("msgTime");
    // Return the message and map to message model
    return globalChatRoomSnapshot.snapshots().map((querySnap) =>
        querySnap.docs.map((snap) => MessageModel.fromSnapshot(snap)).toList());
  }

// Send messages in global chat
  @override
  Future<void> sendMessage(GlobalChatEntity message) async {
    // Get the snapshot of global chat
    final globalChatRoomSnapshot = firestore
        .collection(globalCHatCollectionName)
        .doc(globalChatRoomChannelId)
        .collection("messages");

// Prepare the message model to send message
    final newMessage = MessageModel(
      message: message.message,
      recieverId: message.recieverId,
      msgTime: message.msgTime,
      recieverName: message.recieverName,
      senderId: message.senderId,
      senderName: message.senderName,
      type: message.type,
      chatImgFile: message.chatImgFile,
      senderProfileUrl: message.senderProfileUrl,
      msgDelId: message.msgDelId,
    ).toDoc();
    // Send the message
    globalChatRoomSnapshot.doc(message.msgDelId).set(newMessage);
  }

// Send image to global chat
  @override
  Future<void> uploadChatImage(GlobalChatEntity message) async {
    // final user = firebaseAuth.currentUser!.uid;
    final globalChatRoomSnapshot = firestore
        .collection(globalCHatCollectionName)
        .doc(globalChatRoomChannelId)
        .collection("messages");

    /*   Map<String, dynamic> imageData = {};
    if (message.chatImgFile! != "" || message.chatImgFile != null) {
      imageData['chatImgFile'] = message.chatImgFile;
    }
    Reference reference = storage.ref().child("chatImage").child(user);

    final upload = reference.putFile(imageData['chatImgFile']);
    final imgUrl = (await upload.whenComplete(() {})).ref.getDownloadURL(); */
    final newPost = MessageModel(
      chatImgFile: message.chatImgFile,
      message: message.message ?? "",
      msgTime: Timestamp.now(),
      recieverId: "",
      recieverName: "",
      senderId: message.senderId,
      senderName: message.senderName,
      senderProfileUrl: message.senderProfileUrl,
      type: "IMAGE",
      msgDelId: message.msgDelId,
    ).toDoc();

    try {
      final msgImageDocSnap =
          await globalChatRoomSnapshot.doc(message.msgDelId).get();

      if (!msgImageDocSnap.exists) {
        globalChatRoomSnapshot.doc(message.msgDelId).set(newPost);
      } else {
        // globalChatRoomSnapshot.doc(message.senderId).update(newPost);
      }
    } catch (e) {
      NewAppSnackBar.showSnackbar(msg: "$e");

      log("some error occured $e");
    }
    // return await imgUrl;
  }

  // Delete own chat message from global chat
  @override
  Future<void> deleteChatMsg(GlobalChatEntity message) async {
    // Get the snapshot of global chat collection
    final globalChatRoomSnapshot = firestore
        .collection(globalCHatCollectionName)
        .doc(globalChatRoomChannelId)
        .collection("messages");

    try {
      // Get the message to delete by message id.
      final msgToDelete =
          await globalChatRoomSnapshot.doc(message.msgDelId).get();
      // If message exists
      if (msgToDelete.exists) {
        // Delete the message
        globalChatRoomSnapshot.doc(message.msgDelId).delete();
      }
    } catch (e) {
      NewAppSnackBar.showSnackbar(msg: "$e");
    }
  }

  @override
  Future<void> downloadChatImage(GlobalChatEntity message, String imageName,
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
      final urlPattern = RegExp(
          r'https://firebasestorage.googleapis.com/v0/b/[^/]+/o/(.+)\?alt=media.*');
      final match = urlPattern.firstMatch(message.chatImgFile!);
      if (match != null && match.groupCount >= 1) {
        final path = Uri.decodeFull(match.group(1)!);
        final DownloadTask task =
            storage.ref().child(path).writeToFile(downloadToFile);
        /*  final storageUrlPattern = RegExp(r'^gs://[^/]+/');
      final relativePath =
          message.chatImgFile!.replaceFirst(storageUrlPattern, '');
      final DownloadTask task =
          storage.ref().child(relativePath).writeToFile(downloadToFile); */

        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          // Calculate the progress percentage
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
        await task;
      }

      // Wait until the download completes
      NewAppSnackBar.showSnackbar(
          msg: "Photo downloaded in: ${downloadToFile.path}", duration: 5);
      log('Download complete.');
    } catch (e) {
      NewAppSnackBar.showSnackbar(title: "Error!", msg: "$e");
      log('Failed to download file: $e');
    }

    /*  try {
      // Start the download
      // final firebaseStorageRef = storage.ref().child(path)
      final TaskSnapshot snapshot = await storage
          .ref()
          .child("chatImageFile/${message.senderId}/${message.chatImgFile}")
          .writeToFile(downloadToFile);

      log('Downloaded ${snapshot.totalBytes} bytes.');
    } on FirebaseException catch (e) {
      log('Failed to download file: $e');
    }
  } */
  }

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
        // store on post id then TODO
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
      NewAppSnackBar.showSnackbar(
          msg: "Photo downloaded in: ${downloadToFile.path}", duration: 5);
      log('Download complete.');
    } catch (e) {
      NewAppSnackBar.showSnackbar(title: "Error!", msg: "$e");
      log('Failed to download file: $e');
    }
  }
}
