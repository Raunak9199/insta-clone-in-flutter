import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/repo/add_post_repo_interface.dart';

class ReadPostPostUseCase {
  final AddPostRepositoryInterface repositoryInterface;
  ReadPostPostUseCase({required this.repositoryInterface});

  Stream<List<PostEntity>> call(PostEntity postEntity) =>
      repositoryInterface.fetchAndDisplayPosts(postEntity);
}
