import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class GetUpdateUserUseCase {
  final FirebaseRepositoryInterface repository;

  GetUpdateUserUseCase({required this.repository});

  Future<void> call(UserEntity user, PostEntity post) async {
    return repository.refreshUserData(user, post);
  }
}

class GetUpdateUserImgUseCase {
  final FirebaseRepositoryInterface repository;

  GetUpdateUserImgUseCase({required this.repository});

  Future<void> call(UserEntity user) async {
    return repository.updateUserProfImg(user);
  }
}
