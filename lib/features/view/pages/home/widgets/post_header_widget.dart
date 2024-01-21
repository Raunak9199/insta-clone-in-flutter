import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/home/widgets/post_item_widget.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';

class PostHeaderWidget extends StatelessWidget {
  const PostHeaderWidget({
    super.key,
    required this.widget,
    required this.currentUserUid,
    required this.cont,
  });

  final PostWidget widget;

  final String currentUserUid;
  final Controller cont;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.usersProfilePageView,
              arguments: widget.postEntity.userUid,
            );
          },
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.usersProfilePageView,
                arguments: widget.postEntity.userUid,
              );
            },
            child: Row(
              children: [
                SizedBox(
                  height: 30.h,
                  width: 30.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: ImageDisplayWidget(
                      imgUrl: "${widget.postEntity.ownerProfUrl}",
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  "${widget.postEntity.userName}",
                  style: Get.textTheme.titleLarge!.copyWith(fontSize: 18.sp),
                ),
                SizedBox(width: 10.w),
                const Text("*"),
                SizedBox(width: 10.w),
                Text(
                  DateFormat("dd/MM/yyyy").format(
                    widget.postEntity.timeCreatedAt!.toDate(),
                  ),
                ),
              ],
            ),
          ),
        ),
        widget.postEntity.userUid == currentUserUid
            ? InkWell(
                onTap: () => cont.openSheet(context),
                child: const Icon(Icons.more_vert),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
