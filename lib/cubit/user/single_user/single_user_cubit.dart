import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_single_user_usecase.dart';

part 'single_user_state.dart';

class LoggedInCurrentUserCubit extends Cubit<LoggedInuserState> {
  LoggedInCurrentUserCubit({required this.getSingleUserUseCase})
      : super(LoggedInUserInitial());

  final UserUseCase getSingleUserUseCase;

  Future<void> getSingleUser({required String uid}) async {
    emit(LoggedInUserLoading());
    try {
      getSingleUserUseCase.call(uid).listen((listUsers) {
        emit(LoggedInUserLoaded(user: listUsers.first));
      });
    } on SocketException catch (_) {
      emit(LoggedInUserFailure());
    } catch (_) {
      emit(LoggedInUserFailure());
    }
  }
}
