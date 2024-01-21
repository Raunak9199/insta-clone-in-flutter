import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/cubit/auth/auth_cubit.dart';
import 'package:socio_chat/cubit/user/user_cubit.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class ProfilePageController {
  final BuildContext context;
  final UserEntity currentUser;
  final Function onUserDataUpdated;

  // bool isLoading = false;
  // VoidCallback? onUpdate;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  ProfilePageController(
    this.context,
    this.currentUser,
    this.onUserDataUpdated,
  );

  File? imageFile;

  updateUserData() {
    isLoading.value = true;

    if (imageFile == null) {
      updateProf("");
      onUserDataUpdated();
    } else {
      inj
          .sl<StoreImageToFirebaseUseCase>()
          .call(imageFile, "profImages")
          .then((url) {
        updateProf(url);
        onUserDataUpdated();
      });
    }
    // });
  }

  updateProf(String prof) {
    // setState(() {
    isLoading.value = true;
    // });
    final provider = BlocProvider.of<UserCubit>(context);
    provider
        .updateUserProfImg(
      user: UserEntity(
        uid: currentUser.uid,
        profileUrl: prof,
      ),
    )
        .then((value) {
      // setState(() {
      isLoading.value = false;
      // Navigator.pop(context);
      // });
    });
  }

  openBottomModalSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            // height: ,
            decoration:
                BoxDecoration(color: AppColor.backgroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.h, top: 7.h),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.editProfileView,
                              arguments: currentUser);
                        },
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.penToSquare,
                              color: Colors.black,
                              size: 18.h,
                            ),
                            SizedBox(width: 24.w),
                            const Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                    const Divider(
                      thickness: 1,
                      color: AppColor.secondaryDark,
                    ),
                    SizedBox(height: 7.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: InkWell(
                        onTap: () {
                          openAppDialog(
                            context: context,
                            params: OpenDialogModel(
                                title: "Logout!".tr,
                                subTitle: "Are you sure you want to logout?".tr,
                                onConfirm: () {
                                  BlocProvider.of<AuthCubit>(context)
                                      .loggedOut();
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      Routes.loginView, (route) => false);
                                }
                                // onConfirm: () async => AuthUtils.clearData(),
                                ),
                          );
                        },
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.rightFromBracket,
                              color: Colors.black,
                              size: 18.h,
                            ),
                            SizedBox(width: 24.w),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
  /*  Future chooseImage() async {
    try {
      // if (perm.isGranted) {
      //  await _permissionService.getCameraPermission();
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      // setState(() {
      if (pickedFile != null) {
        imageFile = File(
          pickedFile.path,
        );
        updateUserData();
        var pop = Navigator.canPop(context);
        pop ? Navigator.pop(context) : null;
      } else {
        log("No file selected to upload");
      }
      // });
      /*  } else if (perm.isDenied) {
        return AlertDialog(actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Future.value(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => openAppSettings(),
              child: const Text("Settings")),
        ], title: const Text('Photos Permission'));
      } */
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  } */

  /* updateProf({prof, context, uid}) {
    isLoading = true;
    _updateUI();

    final provider = BlocProvider.of<UserCubit>(context);
    provider
        .updateUserProfImg(
      user: UserEntity(
        uid: uid,
        profileUrl: prof,
      ),
    )
        .then((value) {
      isLoading = false;
      _updateUI();
    });
  }

  _updateUI() {
    if (onUpdate != null) {
      onUpdate!();
    }
  } */

  /*   updateUserData() {
    setState(() {
      isLoading = true;

      if (imageFile == null) {
        updateProf("");
      } else {
        inj
            .sl<StoreImageToFirebaseUseCase>()
            .call(imageFile!, "profImages")
            .then((url) => updateProf(url));
      }
    });
  }

  updateProf(String prof) {
    setState(() {
      isLoading = true;
    });
    final provider = BlocProvider.of<UserCubit>(context);
    provider
        .updateUserProfImg(
      user: UserEntity(
        uid: widget.currentUser.uid,
        profileUrl: prof,
      ),
    )
        .then((value) {
      setState(() {
        isLoading = false;
        // Navigator.pop(context);
      });
    });
  }

  _openBottomModalSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            // height: ,
            decoration:
                BoxDecoration(color: AppColor.backgroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.h, top: 7.h),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.editProfileView,
                              arguments: widget.currentUser);
                        },
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.penToSquare,
                              color: Colors.black,
                              size: 18.h,
                            ),
                            SizedBox(width: 24.w),
                            const Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                    const Divider(
                      thickness: 1,
                      color: AppColor.secondaryDark,
                    ),
                    SizedBox(height: 7.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: InkWell(
                        onTap: () {
                          openAppDialog(
                            context: context,
                            params: OpenDialogModel(
                                title: "Logout!".tr,
                                subTitle: "Are you sure you want to logout?".tr,
                                onConfirm: () {
                                  BlocProvider.of<AuthCubit>(context)
                                      .loggedOut();
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      Routes.loginView, (route) => false);
                                }
                                // onConfirm: () async => AuthUtils.clearData(),
                                ),
                          );
                        },
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.rightFromBracket,
                              color: Colors.black,
                              size: 18.h,
                            ),
                            SizedBox(width: 24.w),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                  ],
                ),
              ),
            ),
          );
        });
  } */