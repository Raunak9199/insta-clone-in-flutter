import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/repository/global_chat_repo_interface.dart';

class SendMessageUsecase {
  final GlobalChatRepoInterface repositoryInterface;

  SendMessageUsecase({required this.repositoryInterface});
  Future<void> call(GlobalChatEntity message) {
    return repositoryInterface.sendMessage(message);
  }
}
