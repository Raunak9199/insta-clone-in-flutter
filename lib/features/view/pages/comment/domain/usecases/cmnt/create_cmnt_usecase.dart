import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/repo/cmnt_and_reply_repo_interface.dart';

class CreateCommentUseCase {
  final CommentAndReplyRepoInterface repositoryInterface;
  CreateCommentUseCase({required this.repositoryInterface});

  Future<void> call(CommentEntity commentEntity) =>
      repositoryInterface.createComment(commentEntity);
}
