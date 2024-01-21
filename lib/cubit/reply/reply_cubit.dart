import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/usecases/replies/create_reply_usecase.dart';
import 'package:socio_chat/features/view/pages/comment/domain/usecases/replies/delete_reply_usecase.dart';
import 'package:socio_chat/features/view/pages/comment/domain/usecases/replies/like_reply_usecase.dart';
import 'package:socio_chat/features/view/pages/comment/domain/usecases/replies/read_reply_usecase.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final CreateReplyUseCase createReplyUseCase;
  final DeleteReplyUseCase deleteReplyUseCase;
  final LikeReplyUseCase likeReplyUseCase;
  final ReadReplyUseCase readReplyUseCase;

  ReplyCubit({
    required this.createReplyUseCase,
    required this.deleteReplyUseCase,
    required this.likeReplyUseCase,
    required this.readReplyUseCase,
  }) : super(ReplyInitial());

  Future<void> readReply({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      readReplyUseCase.call(reply).listen((listReply) {
        emit(ReplyLoaded(replies: listReply));
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> likeReply({required ReplyEntity likeReply}) async {
    emit(ReplyLoading());
    try {
      likeReplyUseCase.call(likeReply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> createReply({required ReplyEntity createReply}) async {
    emit(ReplyLoading());
    try {
      createReplyUseCase.call(createReply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyEntity deleteReply}) async {
    emit(ReplyLoading());
    try {
      deleteReplyUseCase.call(deleteReply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }
}
