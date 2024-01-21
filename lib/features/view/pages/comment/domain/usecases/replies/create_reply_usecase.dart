import 'package:socio_chat/dep_inj/export.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';

class CreateReplyUseCase {
  final CommentAndReplyRepoInterface repositoryInterface;

  CreateReplyUseCase({required this.repositoryInterface});

  Future<void> call(ReplyEntity reply) {
    return repositoryInterface.createReply(reply);
  }
}
