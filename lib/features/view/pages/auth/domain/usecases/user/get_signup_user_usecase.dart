import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class GetSignUpUserUseCase {
  final FirebaseRepositoryInterface repository;

  GetSignUpUserUseCase({required this.repository});

  Future<void> call(UserEntity user) async {
    return repository.registerUserToFirebase(user);
  }
}
