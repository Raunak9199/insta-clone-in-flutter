import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class GetIsSignedInUsecase {
  final FirebaseRepositoryInterface repository;

  GetIsSignedInUsecase({required this.repository});

  Future<bool> call() async {
    return repository.isSignedIn();
  }
}
