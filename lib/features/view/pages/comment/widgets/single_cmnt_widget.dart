import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/cubit/reply/reply_cubit.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_curr_uid_usecase.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';
import 'package:socio_chat/features/view/pages/comment/widgets/single_reply_widget.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  bool isReplying;
  bool show;
  final CommentEntity comment;
  final VoidCallback? onLongPress;
  final VoidCallback? onClick;
  // final void Function(dynamic)? onClick;
  final VoidCallback? likeCmnt;
  final UserEntity userEntity;
  SingleCommentWidget({
    super.key,
    this.isReplying = false,
    required this.comment,
    this.onLongPress,
    this.onClick,
    this.show = true,
    this.likeCmnt,
    required this.userEntity,
    // this.onTap,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  final TextEditingController textEditingController = TextEditingController();
  // bool isLikedComment = false;

  // onLikeChange() {
  //   setState(() {
  //     isLikedComment = !isLikedComment;
  //   });
  // }

  String currentUserUid = "";
  bool view = false;

  @override
  void initState() {
    inj.sl<GetCurrentUserUidUseCase>().call().then((uid) => setState(() {
          currentUserUid = uid;
        }));

    BlocProvider.of<ReplyCubit>(context).readReply(
        reply: ReplyEntity(
      postId: widget.comment.pstId,
      commentId: widget.comment.cmntId,
    ));
    super.initState();
  }

  _deleteReply({required ReplyEntity replyEntity}) {
    BlocProvider.of<ReplyCubit>(context).deleteReply(
      deleteReply: ReplyEntity(
        commentId: replyEntity.commentId,
        postId: replyEntity.postId,
        replyId: replyEntity.replyId,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Reply deleted",
        ),
      ),
    );
  }

  _likeReply({required ReplyEntity replyEntity}) {
    BlocProvider.of<ReplyCubit>(context).likeReply(
      likeReply: ReplyEntity(
        commentId: replyEntity.commentId,
        postId: replyEntity.postId,
        replyId: replyEntity.replyId,
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  getColor() => setState(
        () => (widget.comment.totReplies ?? 0) > 0
            ? AppColor.secondaryDark
            : AppColor.monoGrey3,
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress:
          widget.comment.userUid == currentUserUid ? widget.onLongPress : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18.w,
              width: 18.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: ImageDisplayWidget(
                  imgUrl: widget.comment.userProfUrl,
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
                    "${widget.comment.userName}",
                    style: Get.textTheme.bodyLarge!.copyWith(fontSize: 16.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 24.w, top: 5.h),
                    child: Text("${widget.comment.comment}"),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: widget.likeCmnt,
                        child: Icon(
                          widget.comment.likes!.contains(currentUserUid)
                              ? Icons.thumb_up_alt_rounded
                              : Icons.thumb_up_alt_outlined,
                          color: widget.comment.likes!.contains(currentUserUid)
                              ? AppColor.secondaryDark
                              : AppColor.monoGrey3,
                          size: 20.h,
                        ),
                      ),
                      Text(
                        DateFormat("dd/MM/yyy")
                            .format(widget.comment.timeCreatedAt!.toDate()),
                        style: Get.textTheme.bodyLarge!
                            .copyWith(color: AppColor.monoGrey3),
                      ),
                      InkWell(
                        onTap: () {
                          // widget.onClick!;
                          setState(() {
                            widget.isReplying = !widget.isReplying;
                            widget.show = !widget.show;
                          });
                        },
                        child: Text(
                          "Reply",
                          style: Get.textTheme.bodyLarge!
                              .copyWith(color: AppColor.monoGrey3),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            view = !view;
                          });
                          BlocProvider.of<ReplyCubit>(context).readReply(
                            reply: ReplyEntity(
                              postId: widget.comment.pstId,
                              commentId: widget.comment.cmntId,
                            ),
                          );
                        },
                        child: Text(
                          "view",
                          style: Get.textTheme.bodyLarge!.copyWith(
                            color: getColor(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],
                  ),
                  BlocBuilder<ReplyCubit, ReplyState>(
                      builder: (context, replyState) {
                    if (replyState is ReplyLoaded) {
                      final replies = replyState.replies
                          .where(
                            (e) => e.commentId == widget.comment.cmntId,
                          )
                          .toList();
                      return view
                          ? ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: replies.length,
                              itemBuilder: (context, index) {
                                return NReplyWidget(
                                  replyEntity: replies[index],
                                  deleteReply: () => _deleteReply(
                                    replyEntity: replies[index],
                                  ),
                                  likeReply: () => _likeReply(
                                    replyEntity: replies[index],
                                  ),
                                );
                              })
                          : const SizedBox.shrink();
                    } else {
                      return const Center(
                        child: AppLoader(),
                      );
                    }
                  }),
                  if (widget.isReplying)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColor.monoGrey3,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ProfilePicWidget(height: 30.w, width: 30.w),
                            SizedBox(
                              height: 28.w,
                              width: 28.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: ImageDisplayWidget(
                                  imgUrl: widget.comment.userProfUrl,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextFormField(
                                autofocus: widget.isReplying,
                                style: Get.textTheme.bodyLarge!.copyWith(
                                  color: AppColor.monoAlt.withOpacity(0.9),
                                ),
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Add a reply...",
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: Get.textTheme.bodyLarge!.copyWith(
                                    color: AppColor.monoGrey3,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => createReply(),
                              child: Text(
                                "Post",
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  color: AppColor.secondaryDark,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // reply(autofocus: !widget.isReplying),
  }

  createReply() {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
      createReply: ReplyEntity(
        replyId: const Uuid().v1(),
        commentId: widget.comment.cmntId,
        timeCreateAt: Timestamp.now(),
        likes: const [],
        userName: widget.userEntity.userName,
        comment: textEditingController.text,
        userUid: widget.userEntity.uid,
        postId: widget.comment.pstId,
        ownerProfileUrl: widget.userEntity.profileUrl,
      ),
    )
        .then((value) {
      setState(() {
        textEditingController.clear();
        widget.isReplying = false;
      });
    });
  }
}

  /* reply({required bool? autofocus}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.monoGrey3,
        ),
      ),
      // margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ProfilePicWidget(height: 30.w, width: 30.w),
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColor.secondaryClr,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                  // color: AppColor.monoGrey3,
                  ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              autofocus: autofocus ?? false,
              style: Get.textTheme.bodyLarge!.copyWith(
                color: AppColor.monoAlt.withOpacity(0.9),
              ),
              controller: textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Add a reply...",
                filled: true,
                fillColor: Colors.white,
                hintStyle: Get.textTheme.bodyLarge!.copyWith(
                  color: AppColor.monoGrey3,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Post",
              style: Get.textTheme.bodyMedium!.copyWith(
                color: AppColor.secondaryDark,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  } */

