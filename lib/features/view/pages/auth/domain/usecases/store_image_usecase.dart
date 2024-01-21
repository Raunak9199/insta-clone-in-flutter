import 'dart:io';

import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class StoreImageToFirebaseUseCase {
  final FirebaseRepositoryInterface repository;

  StoreImageToFirebaseUseCase({required this.repository});

  Future<String> call(File? file, String name) async {
    return repository.storeImage(file, name);
  }
}
