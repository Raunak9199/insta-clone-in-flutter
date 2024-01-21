import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/data/data_source/global_chat_remote_ds_interface.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/repository/global_chat_repo_interface.dart';

class GlobalChatRepoImpl implements GlobalChatRepoInterface {
  GlobalChatRemoteDataSourceInterface remoteDataSource;

  GlobalChatRepoImpl({required this.remoteDataSource});

  @override
  Stream<List<GlobalChatEntity>> getMessages() =>
      remoteDataSource.getMessages();

  @override
  Future<void> sendMessage(GlobalChatEntity message) async =>
      remoteDataSource.sendMessage(message);

  @override
  Future<void> uploadChatImage(GlobalChatEntity message) async =>
      remoteDataSource.uploadChatImage(message);
  @override
  Future<void> deleteChatMsg(GlobalChatEntity message) async =>
      remoteDataSource.deleteChatMsg(message);
  @override
  Future<void> downloadChatImage(GlobalChatEntity message, String imageName,
          void Function(double) onProgress) async =>
      remoteDataSource.downloadChatImage(message, imageName, onProgress);
  @override
  Future<void> downloadPostImage(PostEntity postEntity, String imageName,
          void Function(double) onProgress) async =>
      remoteDataSource.downloadPostImage(postEntity, imageName, onProgress);
}
