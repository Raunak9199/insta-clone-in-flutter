import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';

abstract class CommentReplyRemoteDataSourceInterface {
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> fetchAndReadComments(String pstId);
  Future<void> likeComment(CommentEntity comment);
  // Future<void> disLikeComment(CommentEntity comment);
  Future<void> delComment(CommentEntity comment);

  Future<void> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> fetchAndReadReplies(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);
}
