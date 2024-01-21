import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/repo/add_post_repo_interface.dart';

class DeletePostUseCase {
  final AddPostRepositoryInterface repositoryInterface;
  DeletePostUseCase({required this.repositoryInterface});

  Future<void> call(PostEntity postEntity) =>
      repositoryInterface.delPost(postEntity);
}
