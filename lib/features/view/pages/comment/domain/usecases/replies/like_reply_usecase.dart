import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/repo/cmnt_and_reply_repo_interface.dart';

class LikeReplyUseCase {
  final CommentAndReplyRepoInterface repositoryInterface;

  LikeReplyUseCase({required this.repositoryInterface});

  Future<void> call(ReplyEntity reply) {
    return repositoryInterface.likeReply(reply);
  }
}
