import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/repo/cmnt_and_reply_repo_interface.dart';

class ReadCommentUseCase {
  final CommentAndReplyRepoInterface repositoryInterface;
  ReadCommentUseCase({required this.repositoryInterface});

  Stream<List<CommentEntity>> call(String pstId) =>
      repositoryInterface.fetchAndReadComments(pstId);
}
