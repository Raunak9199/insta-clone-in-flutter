import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';

abstract class AddPostRemoteDataSourceInterface {
  Future<void> createPost(PostEntity postEntity);
  Stream<List<PostEntity>> fetchAndDisplayPosts(PostEntity postEntity);
  Future<void> likePost(PostEntity postEntity);
  Future<void> disLikePost(PostEntity postEntity);
  Future<void> delPost(PostEntity postEntity);
  Stream<List<PostEntity>> readCurrentUserPost(String postId);
}
