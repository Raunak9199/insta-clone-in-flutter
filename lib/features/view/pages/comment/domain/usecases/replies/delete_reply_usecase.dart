import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/repo/cmnt_and_reply_repo_interface.dart';

class DeleteReplyUseCase {
  final CommentAndReplyRepoInterface repositoryInterface;

  DeleteReplyUseCase({required this.repositoryInterface});

  Future<void> call(ReplyEntity reply) {
    return repositoryInterface.deleteReply(reply);
  }
}
