import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class GetCurrentUserUidUseCase {
  final FirebaseRepositoryInterface repository;

  GetCurrentUserUidUseCase({required this.repository});

  Future<String> call() async {
    return repository.fetchLoggedInUserUid();
  }
}
