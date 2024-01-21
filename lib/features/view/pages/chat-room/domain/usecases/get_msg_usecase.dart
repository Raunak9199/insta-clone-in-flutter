import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/repository/global_chat_repo_interface.dart';

class GetMessageUsecase {
  final GlobalChatRepoInterface repositoryInterface;

  GetMessageUsecase({required this.repositoryInterface});
  Stream<List<GlobalChatEntity>> call() {
    return repositoryInterface.getMessages();
  }
}
