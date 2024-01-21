import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class FollowUsersUsecase {
  final FirebaseRepositoryInterface repositoryInterface;

  FollowUsersUsecase({required this.repositoryInterface});

  Future<void> call(UserEntity user) async {
    return repositoryInterface.followUser(user);
  }
}
