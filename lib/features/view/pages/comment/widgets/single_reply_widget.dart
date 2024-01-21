import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_curr_uid_usecase.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class NReplyWidget extends StatefulWidget {
  final ReplyEntity replyEntity;
  final VoidCallback? deleteReply;
  final VoidCallback? likeReply;
  const NReplyWidget({
    super.key,
    required this.replyEntity,
    this.deleteReply,
    this.likeReply,
  });

  @override
  State<NReplyWidget> createState() => _NReplyWidgetState();
}

class _NReplyWidgetState extends State<NReplyWidget> {
  String currentUserUid = "";

  @override
  void initState() {
    inj.sl<GetCurrentUserUidUseCase>().call().then((uid) => setState(() {
          currentUserUid = uid;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  InkWell(
        //   // deleteReply: widget.deleteReply,
        //   child:
        Padding(
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 18.w,
            width: 18.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: ImageDisplayWidget(
                imgUrl: widget.replyEntity.ownerProfileUrl,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.replyEntity.userName}",
                  style: Get.textTheme.bodyLarge!.copyWith(fontSize: 16.sp),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 24.w, top: 5.h),
                  child: Text("${widget.replyEntity.comment}"),
                ),
                SizedBox(height: 6.h),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: widget.likeReply,
                      // onLikeChange();
                      // ,
                      child: Icon(
                        widget.replyEntity.likes!.contains(currentUserUid)
                            ? Icons.thumb_up_alt_rounded
                            : Icons.thumb_up_alt_outlined,
                        color:
                            widget.replyEntity.likes!.contains(currentUserUid)
                                ? AppColor.secondaryDark
                                : AppColor.monoGrey3,
                        size: 20.h,
                      ),
                    ),
                    SizedBox(width: 18.w),
                    Text(
                      DateFormat("dd/MM/yyy")
                          .format(widget.replyEntity.timeCreateAt!.toDate()),
                      style: Get.textTheme.bodyLarge!
                          .copyWith(color: AppColor.monoGrey3),
                    ),
                    SizedBox(width: 18.w),
                    widget.replyEntity.userUid == currentUserUid
                        ? GestureDetector(
                            // onTap: widget.deleteReply
                            onTap: widget.deleteReply,
                            // : null,
                            child: Icon(
                              Icons.delete,
                              size: 20.h,
                              color: AppColor.monoGrey3,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ],
        // ),
      ),
    );
  }
}
