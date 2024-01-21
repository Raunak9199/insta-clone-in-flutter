import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/usecases/cmnt/create_cmnt_usecase.dart';
import 'package:socio_chat/features/view/pages/comment/domain/usecases/cmnt/del_cmnt_usecase.dart';
import 'package:socio_chat/features/view/pages/comment/domain/usecases/cmnt/like_cmnt_usecase.dart';
import 'package:socio_chat/features/view/pages/comment/domain/usecases/cmnt/read_cmnt_usecase.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CreateCommentUseCase createCommentUseCase;
  final LikeCommentUseCase likeCommentUseCase;
  final DelCommentUseCase delCommentUseCase;
  final ReadCommentUseCase fetchAndReadCommentsUseCase;

  CommentCubit({
    required this.createCommentUseCase,
    required this.likeCommentUseCase,
    required this.delCommentUseCase,
    required this.fetchAndReadCommentsUseCase,
  }) : super(CommentInitial());

  Future<void> fetchAndReadComments({required String postId}) async {
    emit(CommentLoading());
    try {
      final streamResponse = fetchAndReadCommentsUseCase.call(postId);
      // fetchAndReadCommentsUseCase.call(postId)
      streamResponse.listen((listComments) {
        emit(CommentLoaded(comment: listComments));
      });
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> createComment({required CommentEntity createComment}) async {
    emit(CommentLoading());
    try {
      createCommentUseCase.call(createComment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> deleteComment({required CommentEntity delComment}) async {
    emit(CommentLoading());
    try {
      delCommentUseCase.call(delComment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> likeComment({required CommentEntity likeComment}) async {
    emit(CommentLoading());
    try {
      likeCommentUseCase.call(likeComment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }
}
