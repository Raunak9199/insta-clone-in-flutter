import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class GetSignOutUserUseCase {
  final FirebaseRepositoryInterface repository;

  GetSignOutUserUseCase({required this.repository});

  Future<void> call() async {
    return repository.logoutUserFromFirebase();
  }
}
