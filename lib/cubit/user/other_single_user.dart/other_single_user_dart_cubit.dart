import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_other_single_user_dart_usecase.dart';

part 'other_single_user_dart_state.dart';

class OtherSingleUserDartCubit extends Cubit<OtherSingleUserDartState> {
  OtherSingleUserDartCubit({required this.fetchEveryOtherUserUseCase})
      : super(OtherSingleUserDartInitial());

  final GetSingleOtherUserUseCase fetchEveryOtherUserUseCase;
  Future<void> fetchEveryOtherUser({required String otherUid}) async {
    emit(OtherSingleUserDartLoading());
    try {
      final resp = fetchEveryOtherUserUseCase.call(otherUid);
      resp.listen((users) {
        emit(OtherSingleUserDartLoaded(otherUser: users.first));
      });
    } on SocketException catch (_) {
      emit(OtherSingleUserDartFailure());
    } catch (_) {
      emit(OtherSingleUserDartFailure());
    }
  }
}
