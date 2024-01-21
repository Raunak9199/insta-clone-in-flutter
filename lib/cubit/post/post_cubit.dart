import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/usecases/create_post_usecase.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/usecases/del_post_usecase.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/usecases/dislike_post_usecase.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/usecases/like_post_usecase.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/usecases/read_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final LikePostUseCase likePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final CreatePostUseCase createPostUseCase;
  final ReadPostPostUseCase fetchAndDisplayPostsPostUseCase;
  // final UpdatePostUseCase updatePostUseCase;
  final DisLikePostUseCase disLikePostUseCase;
  PostCubit({
    required this.likePostUseCase,
    required this.deletePostUseCase,
    required this.createPostUseCase,
    required this.fetchAndDisplayPostsPostUseCase,
    // required this.updatePostUseCase,
    required this.disLikePostUseCase,
  }) : super(PostInitial());

  Future<void> fetchAndDisplayPostss({required PostEntity post}) async {
    emit(PostLoading());
    try {
      fetchAndDisplayPostsPostUseCase.call(post).listen((listPosts) {
        emit(PostLoaded(posts: listPosts));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostEntity createPost}) async {
    emit(PostLoading());
    try {
      createPostUseCase.call(createPost);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostEntity delPost}) async {
    emit(PostLoading());
    try {
      deletePostUseCase.call(delPost);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> likePost({required PostEntity likePost}) async {
    emit(PostLoading());
    try {
      likePostUseCase.call(likePost);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> disLikePost({required PostEntity disLikePost}) async {
    emit(PostLoading());
    try {
      disLikePostUseCase.call(disLikePost);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }
}
