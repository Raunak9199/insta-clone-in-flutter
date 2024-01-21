import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/repository/global_chat_repo_interface.dart';

class DownloadPostUsecase {
  final GlobalChatRepoInterface repositoryInterface;

  DownloadPostUsecase({required this.repositoryInterface});
  Future<void> call(
      PostEntity post, String imageName, void Function(double) onProgress) {
    return repositoryInterface.downloadPostImage(post, imageName, onProgress);
  }
}
