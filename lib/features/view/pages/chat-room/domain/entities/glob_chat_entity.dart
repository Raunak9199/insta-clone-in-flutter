import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GlobalChatEntity extends Equatable {
  final String? recieverId;
  final String? senderId;
  final String? senderName;
  final String? recieverName;
  final String? message;
  final String? type;
  final Timestamp? msgTime;
  bool? isSwiping;
  double? swipePosition;
  int? repIndex;
  final String? chatImgFile;
  final String? senderProfileUrl;
  final String? msgDelId;

  GlobalChatEntity({
    this.recieverId,
    this.senderId,
    this.senderName,
    this.recieverName,
    this.message,
    this.type,
    this.msgTime,
    this.repIndex,
    this.chatImgFile,
    this.senderProfileUrl,
    this.msgDelId,
    this.isSwiping = false,
    this.swipePosition = 0,
  });
  @override
  List<Object?> get props => [
        recieverId,
        senderId,
        senderName,
        recieverName,
        message,
        type,
        msgTime,
        isSwiping,
        swipePosition,
        repIndex,
        chatImgFile,
        senderProfileUrl,
        msgDelId,
      ];
}
