import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_elevated_button.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/global-widgets/app_text_form_field.dart';

class AddPostView extends StatefulWidget {
  final UserEntity user;
  const AddPostView({super.key, required this.user});

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  @override
  void dispose() {
    subTitleController.dispose();
    titleController.dispose();
    // imageFile = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppNewAppBar(
        params: AppAppBarModel(
          backgroundColor: AppColor.monoWhite,
          elevation: 3,
          title: "Add a Post".tr,
          titleStyle:
              Get.textTheme.bodyMedium!.copyWith(color: AppColor.monoAlt),
          isBack: true,
          // iconTitleColor: AppColor.monoWhite,
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
                  controller: titleController,
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
                        child:
                            //  widget.user.imgFile != null
                            //     ?
                            ImageDisplayWidget(imagFile: widget.user.imgFile)),
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
                    // isLoading: true,
                    radius: 15.r,
                    isUpperCase: true,
                    style: Get.textTheme.bodyMedium!
                        .copyWith(color: AppColor.monoWhite),
                    onPressed: () => Get.offAllNamed(Routes.bottomNav),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              child: const ImageDisplayWidget(),
            ),
            // CircleAvatar(
            //   radius: 16.r,
            // ),
            SizedBox(width: 10.w),
            Text(
              "Lorem Ipsum",
              style: Get.textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
/* Future<dynamic> post() {
    return openAppDialog(
      params: OpenDialogModel(
        body: SizedBox(
          height: 150.h,
          width: double.maxFinite,
          // color: Colors.black,
          child: Column(
            children: <Widget>[
              AppTextFormField(
                controller: controller.titleController,
                labelText: "Title",
                showBorder: false,
                labelStyle: subheading6.copyWith(color: AppColor.monoAlt),
              ),
              Expanded(
                child: AppTextFormField(
                  controller: controller.subTitleController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  labelText: "Write here.",
                  showBorder: false,
                  maxLines: null,
                  expands: true,
                  // minLines: 5,
                  labelStyle: subheading6.copyWith(color: AppColor.monoAlt),
                ),
              ),
            ],
          ),
        ),
        isDismissible: true,
        title: "Write your thought here!",
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppElevatedButton(
                width: 90.w,
                title: "Cancel",
                isOutlined: true,
              ),
              AppElevatedButton(
                width: 90.w,
                title: "Post",
                isValid: true,
              )
            ],
          ),
        ],
      ),
    );
  } 
  ////
  ///
  // AppTextFormField(
                //   controller: subTitleController,
                //   keyboardType: TextInputType.multiline,
                //   textInputAction: TextInputAction.newline,
                //   labelText: "adPost_write".tr,
                //   showBorder: false,
                //   maxLines: 15,
                //   // minLines: 4,
                //   height: MediaQuery.of(context).size.height,
                //   //when it reach the max it will use scroll
                //   labelStyle: Get.textTheme.bodyMedium!
                //       .copyWith(color: AppColor.monoAlt),
                // ),
  */
