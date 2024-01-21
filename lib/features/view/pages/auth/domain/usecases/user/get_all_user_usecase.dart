import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class GetAllUsersUseCase {
  final FirebaseRepositoryInterface repository;

  GetAllUsersUseCase({required this.repository});

  Stream<List<UserEntity>> call(UserEntity user) {
    return repository.fetchTotalUsersFromFirebase(user);
  }
}
