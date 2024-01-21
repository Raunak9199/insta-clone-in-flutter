import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_create_user_usecase.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_signin_usecase.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_signup_user_usecase.dart';

part 'cred_state.dart';

class CredCubit extends Cubit<CredState> {
  final GetSignInUserUseCase signInUseCase;
  final GetSignUpUserUseCase signUpUseCase;
  // final ForgotPasswordUseCase forgotPasswordUseCase;
  final GetCreateCurrentUserUseCase getCreateCurrentUserUseCase;
  // final GoogleAuthUseCase googleAuthUseCase;

  CredCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    // required this.forgotPasswordUseCase,
    required this.getCreateCurrentUserUseCase,
    // required this.googleAuthUseCase,
  }) : super(CredInitial());

  Future<void> submitSignIn(
      {required String email, required String pass}) async {
    emit(CredentialLoading());
    try {
      await signInUseCase.call(UserEntity(
        email: email,
        password: pass,
      ));
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> submitSignUp({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signUpUseCase.call(user);
      await getCreateCurrentUserUseCase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  // Future<void> submitGoogleAuth() async {
  //   emit(CredentialLoading());
  //   try {
  //     await googleAuthUseCase.googleAuth();
  //     emit(CredentialSuccess());
  //   } on SocketException catch (_) {
  //     emit(CredentialFailure());
  //   } catch (_) {
  //     emit(CredentialFailure());
  //   }
  // }

  // Future<void> forgotPassword({required UserEntity user}) async {
  //   try {
  //     forgotPasswordUseCase.forgotPassword(user.email!);
  //   } on SocketException catch (_) {
  //     emit(CredentialFailure());
  //   } catch (_) {
  //     emit(CredentialFailure());
  //   }
  // }
}
