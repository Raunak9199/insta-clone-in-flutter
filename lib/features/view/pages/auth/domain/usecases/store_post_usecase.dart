import 'dart:io';

import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class StorePostToFirebaseUseCase {
  final FirebaseRepositoryInterface repository;

  StorePostToFirebaseUseCase({required this.repository});

  Future<String> call(File? file, String name, String randId) async {
    return repository.storePost(file, name, randId);
  }
}
