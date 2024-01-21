import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/req_socio_entities.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/cubit/comment/comment_cubit.dart';
import 'package:socio_chat/cubit/reply/reply_cubit.dart';
import 'package:socio_chat/cubit/user/single_user/single_user_cubit.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';
import 'package:socio_chat/features/view/pages/comment/widgets/cmnt_field_widget.dart';
import 'package:socio_chat/features/view/pages/comment/widgets/cmnt_prof_pic_widget.dart';
import 'package:socio_chat/features/view/pages/comment/widgets/no_cmnt_widget.dart';
import 'package:socio_chat/features/view/pages/comment/widgets/single_cmnt_widget.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_bottom_sheet.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:uuid/uuid.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class CommentWidgetM extends StatefulWidget {
  final RequiredSocioIds socioEntity;
  const CommentWidgetM({super.key, required this.socioEntity});

  @override
  State<CommentWidgetM> createState() => _CommentWidgetMState();
}

class _CommentWidgetMState extends State<CommentWidgetM> {
  bool isRepl = false;
  late _CommentController _commentController;
  final TextEditingController commentTextController = TextEditingController();
  // var isDisabled = true.obs;

  @override
  void initState() {
    _commentController = _CommentController(
      socioEnt: widget.socioEntity,
      state: this,
      context: context,
    );
    BlocProvider.of<LoggedInCurrentUserCubit>(context).getSingleUser(
      uid: widget.socioEntity.uid!,
    );
    BlocProvider.of<CommentCubit>(context).fetchAndReadComments(
      postId: widget.socioEntity.pstId!,
    );
    super.initState();
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  final bool showField = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppNewAppBar(
        params: AppAppBarModel(
          title: "Comments",
          titleStyle: Get.textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
          isBack: Platform.isAndroid,
          isIosBack: Platform.isIOS,
          backgroundColor: AppColor.backgroundColor,
        ),
      ),
      resizeToAvoidBottomInset: isRepl == false,
      body: BlocBuilder<LoggedInCurrentUserCubit, LoggedInuserState>(
        builder: (context, userState) {
          if (userState is LoggedInUserLoaded) {
            final singUser = userState.user;

            return BlocBuilder<CommentCubit, CommentState>(
              builder: (context, comstate) {
                if (comstate is CommentLoaded) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h)
                            .copyWith(top: 5.h),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, Routes.usersProfilePageView,
                              arguments: widget.socioEntity.uid),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.r),
                                child: ImageDisplayWidget(
                                  height: 30.w,
                                  width: 30.w,
                                  imgUrl: singUser.profileUrl!,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "${singUser.userName}",
                                style: Get.textTheme.headlineSmall!
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.w),
                        comstate.comment.isEmpty
                            ? const NoCommentWidget()
                            : Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (_, i) =>
                                        SizedBox(height: 8.h),
                                    itemCount: comstate.comment.length,
                                    itemBuilder: (context, index) {
                                      final comment = comstate.comment[index];
                                      return BlocProvider(
                                        create: (_) => inj.sl<ReplyCubit>(),
                                        child: SingleCommentWidget(
                                          isReplying: isRepl,
                                          userEntity: singUser,
                                          comment: comment,
                                          show: showField,
                                          // onClick: () => navToProfile(comment),
                                          onClick: () => Navigator.pushNamed(
                                            context,
                                            Routes.usersProfilePageView,
                                            arguments: singUser.uid,
                                          ),
                                          likeCmnt: () => _commentController
                                              .likeComment(comment),
                                          onLongPress: () {
                                            _commentController.openBottomSheet(
                                                context, comment);
                                          },
                                        ),
                                      );
                                    }),
                              ),
                        SizedBox(width: 5.w),
                        // const Spacer(),
                        !isRepl
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Container(
                                  width: double.maxFinite,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: AppColor.monoGrey3,
                                    ),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // ProfilePicWidget(height: 30.w, width: 30.w),
                                      CmntProfilePicWidget(singUser: singUser),
                                      SizedBox(width: 8.w),
                                      CommentFieldWidget(
                                        isRepl: isRepl,
                                        commentController:
                                            commentTextController,
                                      ),
                                      GestureDetector(
                                        onTap: () => commentTextController
                                                .text.isEmpty
                                            ? {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Can't send an empty comment"),
                                                  ),
                                                ),
                                              }
                                            : _commentController
                                                .createComment(singUser),
                                        child: const Icon(
                                          Icons.send,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: AppLoader(),
                );
              },
            );
          }
          return const Center(
            child: AppLoader(),
          );
        },
      ),
    );
  }

  Color iconColor = Colors.grey;
  getColor() {
    return commentTextController.text == ""
        ? setState(() {
            iconColor = Colors.grey;
          })
        : setState(() {
            iconColor = Colors.blue;
          });
  }

  void render(fn) => setState(fn);
}

class _CommentController {
  final BuildContext context;
  final _CommentWidgetMState state;
  final RequiredSocioIds socioEnt;

  _CommentController({
    required this.socioEnt,
    required this.state,
    required this.context,
  });
  openBottomSheet(BuildContext context, CommentEntity commentEntity) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BottomSheetAppBar(
            // isDivider: true,
            // haveCloseIcon: true,
            rowAxisAlignment: MainAxisAlignment.start,
            colCrossAxisAlignment: CrossAxisAlignment.start,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => delComment(commentEntity.cmntId!),
                  child: const Text("Delete Comment"),
                ),
                SizedBox(height: 15.h),
              ],
            ),
            // closeIcon: FaIcon(
            //   FontAwesomeIcons.xmark,
            //   color: Colors.black,
            //   size: 17.w,
            // ),
          ),
        ),
      );

  delComment(String cmntId) {
    BlocProvider.of<CommentCubit>(context).deleteComment(
      delComment: CommentEntity(
        cmntId: cmntId,
        pstId: socioEnt.pstId,
        userUid: socioEnt.uid,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Comment Deleted."),
      ),
    );
  }

  likeComment(CommentEntity commentEntity) {
    BlocProvider.of<CommentCubit>(context).likeComment(
      likeComment: CommentEntity(
        cmntId: commentEntity.cmntId,
        pstId: commentEntity.pstId,
        userUid: socioEnt.uid,
      ),
    );
  }

  createComment(UserEntity currUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
      createComment: CommentEntity(
        cmntId: const Uuid().v1(),
        timeCreatedAt: Timestamp.now(),
        likes: const [],
        totReplies: 0,
        userName: currUser.userName,
        comment: state.commentTextController.text,
        userUid: currUser.uid,
        pstId: state.widget.socioEntity.pstId,
        userProfUrl: currUser.profileUrl,
      ),
    )
        .then((value) {
      state.render(() {
        state.commentTextController.clear();
      });
    });
  }
}
