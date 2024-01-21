import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/follow_user_usecase.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_all_user_usecase.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required this.updateUserUseCase,
    required this.fetchTotalUsersFromFirebaseUseCase,
    required this.followUsersUsecase,
    required this.updateUserImgUseCase,
  }) : super(UserInitial());
  final GetUpdateUserUseCase updateUserUseCase;
  final GetAllUsersUseCase fetchTotalUsersFromFirebaseUseCase;
  final FollowUsersUsecase followUsersUsecase;
  final GetUpdateUserImgUseCase updateUserImgUseCase;

  Future<void> getUsers({required UserEntity user}) async {
    emit(UserLoading());
    try {
      fetchTotalUsersFromFirebaseUseCase.call(user).listen((listUsers) {
        emit(UserLoaded(users: listUsers));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser(
      {required UserEntity user, required PostEntity post}) async {
    emit(UserLoading());
    try {
      updateUserUseCase.call(user, post);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUserProfImg({required UserEntity user}) async {
    emit(UserLoading());
    try {
      updateUserImgUseCase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> followUser({required UserEntity user}) async {
    emit(UserLoading());
    try {
      followUsersUsecase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
