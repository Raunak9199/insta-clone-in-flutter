import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/usecases/read_curr_post_usecase.dart';

part 'current_post_state.dart';

class CurrentPostCubit extends Cubit<CurrentPostState> {
  final ReadCurrentPostPostUseCase readCurrentUserPostUseCase;
  CurrentPostCubit({required this.readCurrentUserPostUseCase})
      : super(CurrentPostInitial());

  Future<void> getCurrentSinglePost({required String postId}) async {
    emit(CurrentPostLoading());
    try {
      readCurrentUserPostUseCase.call(postId).listen((listPost) {
        emit(CurrentPostLoaded(postEntity: listPost.first));
      });
    } on SocketException catch (_) {
      emit(CurrentPostFailure());
    } catch (_) {
      emit(CurrentPostFailure());
    }
  }
}
