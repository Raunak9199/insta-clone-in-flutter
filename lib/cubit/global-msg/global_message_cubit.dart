import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/usecases/del_msg_usecase.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/usecases/get_msg_usecase.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/usecases/send_msg_usecase.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/store_chat_image_usecase.dart';

part 'global_message_state.dart';

class GlobalMessageCubit extends Cubit<GlobalMessageState> {
  GlobalMessageCubit({
    required this.sendMessageUsecase,
    required this.getMessageUsecase,
    required this.uploadMessageImageUseCase,
    required this.deleteMessageUseCase,
  }) : super(GlobalMessageInitial());

  final SendMessageUsecase sendMessageUsecase;
  final GetMessageUsecase getMessageUsecase;
  final StoreGlobalChatImageUseCase uploadMessageImageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;

  Future<void> sendGlobalMessage(GlobalChatEntity message) async {
    try {
      await sendMessageUsecase.call(message);
    } on SocketException catch (e) {
      log("Error:=> $e");
      emit(GlobalMessageFailure());
    }
  }

  Future<void> getGlobalMessage() async {
    try {
      final msgs = getMessageUsecase.call();
      msgs.listen((msg) {
        emit(GlobalMessageLoaded(message: msg));
      });
    } on SocketException catch (e) {
      log("Error:=> $e");
      emit(GlobalMessageFailure());
    }
  }

  Future<void> uploadChatImage(GlobalChatEntity message) async {
    emit(GlobalMessageLoading());
    try {
      uploadMessageImageUseCase.call(message);
    } on SocketException catch (_) {
      emit(GlobalMessageFailure());
    } catch (_) {
      emit(GlobalMessageFailure());
    }
  }

  Future<void> deleteChatMsg({required GlobalChatEntity delMsg}) async {
    emit(GlobalMessageLoading());
    try {
      deleteMessageUseCase.call(delMsg);
    } on SocketException catch (_) {
      emit(GlobalMessageFailure());
    } catch (_) {
      emit(GlobalMessageFailure());
    }
  }
}
