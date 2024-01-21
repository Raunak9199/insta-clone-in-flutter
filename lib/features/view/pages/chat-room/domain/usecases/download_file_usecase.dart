import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/repository/global_chat_repo_interface.dart';

class DownloadFileUsecase {
  final GlobalChatRepoInterface repositoryInterface;

  DownloadFileUsecase({required this.repositoryInterface});
  Future<void> call(GlobalChatEntity message, String imageName,
      void Function(double) onProgress) {
    return repositoryInterface.downloadChatImage(
        message, imageName, onProgress);
  }
}
