import 'package:flutter/material.dart';

abstract class PermissionService {
  Future getImgPermission();

  Future<bool> manageImgPermission(BuildContext context);

  Future getCameraPermission();

  Future<bool> manageCameraPermission(BuildContext context);
}
