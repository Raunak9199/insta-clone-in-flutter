import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:socio_chat/core/services/permission_repo_interface.dart';

class PermissionManager implements PermissionService {
  @override
  Future<PermissionStatus> getImgPermission() async {
    return await Permission.photos.request();
  }

  @override
  Future<bool> manageImgPermission(BuildContext context) async {
    PermissionStatus photosPermissionStatus = await getImgPermission();

    if (photosPermissionStatus != PermissionStatus.granted) {
      await showPhotoDial(context);
      return false;
    }
    return true;
  }

  showPhotoDial(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Future.value(false);
                  return;
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () => openAppSettings(),
                child: const Text("Settings")),
          ],
          title: const Text('Photos Permission'),
        ),
      );
  @override
  Future<PermissionStatus> getCameraPermission() async {
    return await Permission.camera.request();
  }

  @override
  Future<bool> manageCameraPermission(BuildContext context) async {
    PermissionStatus cameraPermissionStatus = await getCameraPermission();

    if (cameraPermissionStatus != PermissionStatus.granted) {
      await showDial(context);
      return false;
    }
    return true;
  }

  showDial(context) => showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          // onConfirm: () => openAppSettings(),
          title: Text('Camera Permission'),
        ),
      );
}
