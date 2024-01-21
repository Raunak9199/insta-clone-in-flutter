import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/store_post_usecase.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_elevated_button.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/global-widgets/app_text_form_field.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class UploadPostWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostWidget({super.key, required this.currentUser});

  @override
  State<UploadPostWidget> createState() => _UploadPostWidgetState();
}

class _UploadPostWidgetState extends State<UploadPostWidget> {
  final TextEditingController descController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    descController.dispose();
    imageFile = null;
    super.dispose();
  }

  onwillPop() {
    return showDialog(
        context: context,
        builder: (_) {
          return const AlertDialog(
            title: Text('Stop uploading?'),
            content: Text('Are you sure you want to stop uploading?'),
            actions: [
              AppElevatedButton(title: "Yes"),
              AppElevatedButton(title: "No")
            ],
          );
        });
  }

  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  Future chooseImage() async {
    try {
      // var status = await Permission.
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      setState(() {
        if (pickedFile != null) {
          imageFile = File(
            pickedFile.path,
          );

          log(imageFile!.path);
        } else {
          log("No file selected to upload");
        }
      });
    } catch (e) {
      AppSnackBar.showSnackbar(msg: "$e", title: "Error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageFile == null
        ? AppScaffold(
            // onWillPop: ,
            appBar: AppNewAppBar(
                params: AppAppBarModel(
              title: "Upload Post",
              titleStyle: Get.textTheme.bodyLarge,
            )),
            backgroundColor: AppColor.backgroundColor,
            body: InkWell(
              onTap: chooseImage,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColor.monoGrey3,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 40.r,
                    child: Icon(
                      Icons.upload_outlined,
                      size: 50.w,
                    ),
                  ),
                ),
              ),
            ),
          )
        : AppScaffold(
            onWillPop: () => isLoading ? onwillPop() : null,
            appBar: AppNewAppBar(
              params: AppAppBarModel(
                backgroundColor: AppColor.monoWhite,
                elevation: 3,
                title: "Add a Post".tr,
                titleStyle:
                    Get.textTheme.bodyMedium!.copyWith(color: AppColor.monoAlt),
                // isBack: true,
                leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        imageFile = null;
                      });
                      // Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColor.darkGreyClr,
                    )),
                // customPop: () => Get.offAllNamed(Routes.bottomNav),
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      cardComponent(),
                      SizedBox(height: 10.h),
                      AppTextFormField(
                        controller: descController,
                        labelText: "Add a title...",
                        showBorder: false,
                        labelStyle: Get.textTheme.bodyMedium!
                            .copyWith(color: AppColor.monoAlt),
                      ),
                      SizedBox(height: 10.h),
                      Card(
                        elevation: 2,
                        color: Colors.grey.shade300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.r),
                          ),
                          child: Container(
                              height: 220.h,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.r),
                                ),
                              ),
                              child: ImageDisplayWidget(imagFile: imageFile)),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Center(
                        child: AppElevatedButton(
                          height: 42.h,
                          width: double.maxFinite,
                          title: "Add Post",
                          color: AppColor.secondaryDark,
                          isValid: true,
                          isLoading: isLoading,
                          radius: 15.r,
                          isUpperCase: true,
                          style: Get.textTheme.bodyMedium!
                              .copyWith(color: AppColor.monoWhite),
                          onPressed: submitPostImage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  submitPostImage() {
    setState(() {
      isLoading = true;
    });

    inj
        .sl<StorePostToFirebaseUseCase>()
        .call(imageFile, "posts", const Uuid().v1())
        .then(
          (postImgUrl) => createPostImage(
            imageUrl: postImgUrl,
          ),
        );
  }

  createPostImage({required String imageUrl}) {
    FocusScope.of(context).requestFocus(FocusNode());
    BlocProvider.of<PostCubit>(context)
        .createPost(
      createPost: PostEntity(
        userUid: widget.currentUser.uid,
        userName: widget.currentUser.userName,
        ownerProfUrl: widget.currentUser.profileUrl,
        postId: const Uuid().v1(),
        postUrl: imageUrl,
        likes: const [],
        disLikes: const [],
        totalLike: 0,
        totalComments: 0,
        desc: descController.text,
        timeCreatedAt: Timestamp.now(),
      ),
    )
        .then(
      (value) {
        setState(() {
          isLoading = false;
          descController.clear();
          imageFile = null;
          log("Uploaded");
        });
      },
    );
  }

  cardComponent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 40.w,
              width: 40.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: ImageDisplayWidget(
                  imgUrl: widget.currentUser.profileUrl,
                ),
              ),
            ),
            // CircleAvatar(
            //   radius: 16.r,
            // ),
            SizedBox(width: 10.w),
            Text(
              "${widget.currentUser.name}",
              style: Get.textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
