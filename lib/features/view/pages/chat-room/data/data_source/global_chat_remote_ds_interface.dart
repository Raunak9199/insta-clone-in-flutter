import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';

abstract class GlobalChatRemoteDataSourceInterface {
  Future<void> sendMessage(GlobalChatEntity message);

  Stream<List<GlobalChatEntity>> getMessages();
  Future<void> uploadChatImage(GlobalChatEntity message);
  Future<void> deleteChatMsg(GlobalChatEntity message);
  Future<void> downloadChatImage(GlobalChatEntity message, String imageName,
      void Function(double) onProgress);
  Future<void> downloadPostImage(PostEntity postEntity, String imageName,
      void Function(double) onProgress);
}
