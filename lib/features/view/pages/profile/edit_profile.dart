import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/profile/controllers/edit_profile_controller.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';
import 'package:socio_chat/global-widgets/app_elevated_button.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/global-widgets/app_text_form_field.dart';

class EditProfile extends StatefulWidget {
  final UserEntity currUser;
  const EditProfile({super.key, required this.currUser});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController? nameController;
  late TextEditingController? userNameController;
  late TextEditingController? aboutController;

  void render(fn) {
    setState(fn);
  }

  late EditProfileController profController;
  late _EditProfileController editProfController;

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          } else {
            setState(() {
              isAlertSet = false;
            });
          }
        },
      );
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Connectivity'),
          content:
              const Text('Please make sure you have an internet connection.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                bool? shouldClose = await openAppDialog(
                  context: context,
                  params: OpenDialogModel(
                    title: "Exit app?",
                    isDismissible: true,
                    subTitle: "Are you sure, you want to exit the app?".tr,
                  ),
                );

                return Future.value(shouldClose ?? false);
              },
              child: const Text("Exit"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  @override
  void initState() {
    getConnectivity();
    profController = EditProfileController();
    editProfController = _EditProfileController(this, widget.currUser);
    nameController = TextEditingController(text: widget.currUser.name);
    userNameController = TextEditingController(text: widget.currUser.userName);
    aboutController = TextEditingController(text: widget.currUser.about);
    super.initState();
  }

  @override
  void dispose() {
    nameController!.dispose();
    userNameController!.dispose();
    aboutController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppNewAppBar(
        params: AppAppBarModel(
          title: "Edit Profile",
          titleStyle: Get.textTheme.headlineSmall,
          iconTitleColor: AppColor.monoAlt,
          isBack: Platform.isAndroid,
          isIosBack: Platform.isIOS,
          backgroundColor: AppColor.backgroundColor,
          elevation: 1,
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100.w,
                    width: 100.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: ImageDisplayWidget(
                        imgUrl: widget.currUser.profileUrl,
                        // imagFile: imageFile,
                      ),
                    ),
                  ),
                ],
              ),
              AppTextFormField(
                controller: nameController,
                labelText: "Name",
                showBorder: false,
                // labelStyle: ,
              ),
              AppTextFormField(
                controller: userNameController,
                labelText: "Username",
                showBorder: false,
                // labelStyle: ,
              ),
              AppTextFormField(
                controller: aboutController,
                labelText: "About",
                showBorder: false,
                // labelStyle: ,
              ),
              SizedBox(height: 20.h),
              AppElevatedButton(
                height: 45.h,
                title: "Save",
                isLoading: profController.isLoading.value,
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: AppColor.monoWhite, fontSize: 17.sp),
                isValid: true,
                color: AppColor.secondaryDark,
                onPressed: () {
                  editProfController.updateData(context);
                  nameController!.clear();
                  userNameController!.clear();
                  aboutController!.clear();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileController {
  _EditProfileState state;
  UserEntity userEntity;
  _EditProfileController(this.state, this.userEntity);
  updateLoader() {
    state.render(() {
      state.profController.isLoading;
    });
  }

  updateData(context) {
    state.render(() {
      state.profController.update(
        context: context,
        user: UserEntity(
          uid: userEntity.uid,
          name: state.nameController!.text,
          userName: state.userNameController!.text,
          about: state.aboutController!.text,
        ),
      );
      /*  .then((v) {
        // state.nameController!.clear();
        // state.userNameController!.clear();
        // state.aboutController!.clear();
      }); */
    });
  }
}
