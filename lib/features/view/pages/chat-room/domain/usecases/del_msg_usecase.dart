import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/repository/global_chat_repo_interface.dart';

class DeleteMessageUseCase {
  final GlobalChatRepoInterface repositoryInterface;
  DeleteMessageUseCase({required this.repositoryInterface});

  Future<void> call(GlobalChatEntity message) =>
      repositoryInterface.deleteChatMsg(message);
}
