import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/repository/global_chat_repo_interface.dart';

class StoreGlobalChatImageUseCase {
  final GlobalChatRepoInterface repository;

  StoreGlobalChatImageUseCase({required this.repository});

  Future<void> call(GlobalChatEntity message) async {
    return repository.uploadChatImage(message);
  }
}
