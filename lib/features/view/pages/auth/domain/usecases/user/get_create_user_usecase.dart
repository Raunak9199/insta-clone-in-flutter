import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class GetCreateCurrentUserUseCase {
  final FirebaseRepositoryInterface repository;

  GetCreateCurrentUserUseCase({required this.repository});

  Future<void> call(UserEntity user) async {
    return repository.implementLoggedInUserData(user);
  }
}
