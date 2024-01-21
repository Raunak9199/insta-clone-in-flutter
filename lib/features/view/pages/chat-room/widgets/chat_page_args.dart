import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';

class ChatPageArguments {
  final UserEntity user;
  final int lastSeenMessageIndex;

  ChatPageArguments({
    required this.user,
    required this.lastSeenMessageIndex,
  });
}
