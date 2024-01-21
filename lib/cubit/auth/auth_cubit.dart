import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_curr_uid_usecase.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_signout_user_usecase.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/is_signed_in_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetIsSignedInUsecase isSIgnInUseCase;
  final GetCurrentUserUidUseCase fetchLoggedInUserDataId;
  final GetSignOutUserUseCase logoutUserFromFirebaseUseCase;
  // AuthCubit(this.isSIgnInUseCase, this.fetchLoggedInUserDataId, this.logoutUserFromFirebaseUseCase) : super(AuthInitial());

  AuthCubit({
    required this.isSIgnInUseCase,
    required this.fetchLoggedInUserDataId,
    required this.logoutUserFromFirebaseUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      final issignIn = await isSIgnInUseCase.call();
      if (issignIn) {
        final uid = await fetchLoggedInUserDataId.call();
        emit(AuthenticatedState(uid: uid));
      } else {
        emit(UnAuthenticatedState());
      }
    } on SocketException catch (_) {
      emit(UnAuthenticatedState());
    }
  }

  Future<void> loggedOut() async {
    try {
      // Nav.pop();
      logoutUserFromFirebaseUseCase.call();
      emit(UnAuthenticatedState());
      // Nav.pushAndRemoveUntilNamed(Routes.loginView);
    } catch (_) {
      emit(UnAuthenticatedState());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await fetchLoggedInUserDataId.call();
      emit(AuthenticatedState(uid: uid));
    } catch (_) {
      emit(UnAuthenticatedState());
    }
  }
}
