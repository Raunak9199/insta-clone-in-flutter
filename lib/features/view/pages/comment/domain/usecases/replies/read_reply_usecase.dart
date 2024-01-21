import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/repo/cmnt_and_reply_repo_interface.dart';

class ReadReplyUseCase {
  final CommentAndReplyRepoInterface repositoryInterface;

  ReadReplyUseCase({required this.repositoryInterface});

  Stream<List<ReplyEntity>> call(ReplyEntity reply) {
    return repositoryInterface.fetchAndReadReplies(reply);
  }
}
