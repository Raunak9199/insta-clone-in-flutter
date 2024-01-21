import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class UserUseCase {
  final FirebaseRepositoryInterface repository;

  UserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uid) {
    return repository.fetchLoggedInUserData(uid);
  }
}
