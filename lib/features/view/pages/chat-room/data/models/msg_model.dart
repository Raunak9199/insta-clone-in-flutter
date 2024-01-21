// ignore_for_file: annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';

class MessageModel extends GlobalChatEntity {
  MessageModel({
    String? recieverId,
    String? senderId,
    String? senderName,
    String? recieverName,
    String? message,
    String? type,
    Timestamp? msgTime,
    String? chatImgFile,
    String? senderProfileUrl,
    String? msgDelId,
  }) : super(
          recieverId: recieverId,
          senderId: senderId,
          senderName: senderName,
          recieverName: recieverName,
          message: message,
          type: type,
          msgTime: msgTime,
          chatImgFile: chatImgFile,
          senderProfileUrl: senderProfileUrl,
          msgDelId: msgDelId,
        );

  Map<String, dynamic> toDoc() {
    return {
      "recieverId": recieverId,
      "senderId": senderId,
      "senderName": senderName,
      "recieverName": recieverName,
      "message": message,
      "type": type,
      "msgTime": msgTime,
      "chatImgFile": chatImgFile,
      "senderProfileUrl": senderProfileUrl,
      "msgDelId": msgDelId,
    };
  }

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    return MessageModel(
      recieverId: snapshot.get('recieverId') ?? "",
      senderId: snapshot.get('senderId') ?? "",
      senderName: snapshot.get('senderName') ?? "",
      recieverName: snapshot.get('recieverName') ?? "",
      message: snapshot.get('message') ?? "",
      type: snapshot.get('type') ?? "",
      msgTime: snapshot.get('msgTime') ?? "",
      chatImgFile: snapshot.get('chatImgFile') ?? "",
      senderProfileUrl: snapshot.get('senderProfileUrl') ?? "",
      msgDelId: snapshot.get('msgDelId') ?? "",
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      recieverId: json['recieverId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      recieverName: json['recieverName'],
      message: json['message'],
      type: json['type'],
      msgTime: json['msgTime'],
      chatImgFile: json['chatImgFile'],
      senderProfileUrl: json['senderProfileUrl'],
      msgDelId: json['msgDelId'],
    );
  }
}

/*  recieverId: snapshot.data().toString().contains('recieverId')
          ? snapshot.get('recieverId')
          : '',
      senderId: snapshot.data().toString().contains('senderId')
          ? snapshot.get('senderId')
          : '',
      senderName: snapshot.data().toString().contains('senderName')
          ? snapshot.get('senderName')
          : '',
      recieverName: snapshot.data().toString().contains('recieverName')
          ? snapshot.get('recieverName')
          : '',
      message: snapshot.data().toString().contains('message')
          ? snapshot.get('message')
          : '',
      type: snapshot.data().toString().contains('type')
          ? snapshot.get('type')
          : '',
      msgTime: snapshot.data().toString().contains('msgTime')
          ? snapshot.get('msgTime')
          : '', */