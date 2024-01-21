import 'package:socio_chat/features/view/pages/comment/data/data-source/cmnt_reply_remote_ds_interface.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/repo/cmnt_and_reply_repo_interface.dart';

class CommentAndReplyRepoImpl implements CommentAndReplyRepoInterface {
  final CommentReplyRemoteDataSourceInterface remoteDataSource;

  CommentAndReplyRepoImpl({required this.remoteDataSource});
  @override
  Future<void> createComment(CommentEntity comment) async =>
      remoteDataSource.createComment(comment);

  @override
  Future<void> delComment(CommentEntity comment) async =>
      remoteDataSource.delComment(comment);

  @override
  Future<void> likeComment(CommentEntity comment) async =>
      remoteDataSource.likeComment(comment);

  @override
  Stream<List<CommentEntity>> fetchAndReadComments(String pstId) =>
      remoteDataSource.fetchAndReadComments(pstId);

  @override
  Future<void> createReply(ReplyEntity reply) async =>
      remoteDataSource.createReply(reply);

  @override
  Future<void> deleteReply(ReplyEntity reply) async =>
      remoteDataSource.deleteReply(reply);

  @override
  Future<void> likeReply(ReplyEntity reply) async =>
      remoteDataSource.likeReply(reply);

  @override
  Stream<List<ReplyEntity>> fetchAndReadReplies(ReplyEntity reply) =>
      remoteDataSource.fetchAndReadReplies(reply);
}
