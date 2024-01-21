import 'package:socio_chat/features/view/pages/add-post/data/data_source/addpost_remote_ds_interface.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/repo/add_post_repo_interface.dart';

class AddPostRepositoryImpl implements AddPostRepositoryInterface {
  final AddPostRemoteDataSourceInterface remoteDataSource;
  AddPostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createPost(PostEntity postEntity) async =>
      remoteDataSource.createPost(postEntity);

  @override
  Future<void> delPost(PostEntity postEntity) async =>
      remoteDataSource.delPost(postEntity);

  @override
  Future<void> likePost(PostEntity postEntity) async =>
      remoteDataSource.likePost(postEntity);
  @override
  Future<void> disLikePost(PostEntity postEntity) async =>
      remoteDataSource.disLikePost(postEntity);

  @override
  Stream<List<PostEntity>> fetchAndDisplayPosts(PostEntity postEntity) =>
      remoteDataSource.fetchAndDisplayPosts(postEntity);
  @override
  Stream<List<PostEntity>> readCurrentUserPost(String postId) =>
      remoteDataSource.readCurrentUserPost(postId);
}
