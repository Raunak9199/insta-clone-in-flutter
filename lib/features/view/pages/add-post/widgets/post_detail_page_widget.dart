import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/req_socio_entities.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_curr_uid_usecase.dart';
import 'package:socio_chat/cubit/post/curr_post/current_post_cubit.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_bottom_sheet.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;
import 'package:socio_chat/global-widgets/app_loader.dart';

class PostDetailPageWidget extends StatefulWidget {
  final String postId;
  const PostDetailPageWidget({super.key, required this.postId});

  @override
  State<PostDetailPageWidget> createState() => _PostDetailPageWidgetState();
}

class _PostDetailPageWidgetState extends State<PostDetailPageWidget> {
  bool isAnimating = false;
  String currentUserUid = "";

  @override
  void initState() {
    BlocProvider.of<CurrentPostCubit>(context)
        .getCurrentSinglePost(postId: widget.postId);

    inj.sl<GetCurrentUserUidUseCase>().call().then((uid) => setState(() {
          currentUserUid = uid;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CurrentPostCubit, CurrentPostState>(
          builder: (context, singlePostState) {
        if (singlePostState is CurrentPostLoaded) {
          final currSinglePost = singlePostState.postEntity;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 30.h,
                          width: 30.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: ImageDisplayWidget(
                              imgUrl: "${currSinglePost.ownerProfUrl}",
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "${currSinglePost.userName}",
                          style: Get.textTheme.bodyMedium,
                        ),
                        SizedBox(width: 10.w),
                        const Text("*"),
                        SizedBox(width: 10.w),
                        Text(
                          DateFormat("dd/MM/yyyy").format(
                            currSinglePost.timeCreatedAt!.toDate(),
                          ),
                        ),
                      ],
                    ),
                    currSinglePost.userUid == currentUserUid
                        ? InkWell(
                            onTap: () =>
                                openBottomSheet(context, currSinglePost),
                            child: const Icon(Icons.more_vert),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: 10.h),

                Icon(
                  Icons.thumb_up_alt,
                  color: Colors.red,
                  size: 80.w,
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("${currSinglePost.totalLike}"),
                    GestureDetector(
                      onTap: likePost,
                      child: Icon(
                        currSinglePost.likes!.contains(currentUserUid)
                            ? Icons.thumb_up_alt
                            : Icons.thumb_up_alt_outlined,
                        color: currSinglePost.likes!.contains(currentUserUid)
                            ? AppColor.secondaryDark
                            : AppColor.monoAlt,
                      ),
                    ),
                    // SizedBox(width: 12.w),
                    // Text("${postEntity.}"),
                    // Text("${currSinglePost.totalDisLike ?? 0}"),
                    // GestureDetector(
                    //   onTap: disLikePost,
                    //   child: Icon(
                    //     currSinglePost.disLikes!.contains(currentUserUid)
                    //         ? Icons.thumb_down_alt
                    //         : Icons.thumb_down_alt_outlined,
                    //     color: currSinglePost.disLikes!.contains(currentUserUid)
                    //         ? AppColor.secondaryDark
                    //         : AppColor.monoAlt,
                    //   ),
                    // ),

                    SizedBox(width: 12.w),
                    Text("${currSinglePost.totalComments}"),
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.commentView,
                        arguments: RequiredSocioIds(
                          pstId: currSinglePost.postId,
                          uid: currentUserUid,
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.comment,
                        color: AppColor.monoAlt,
                        size: 22.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    FaIcon(
                      FontAwesomeIcons.paperPlane,
                      color: AppColor.monoAlt,
                      size: 22.w,
                    ),
                  ],
                ),
                SizedBox(height: 12.w),
                Text(
                  "${currSinglePost.desc}",
                  style: Get.textTheme.bodyMedium!
                      .copyWith(color: AppColor.secondaryClr),
                ),
                SizedBox(height: 10.w),
                currSinglePost.totalComments == 0
                    ? InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.commentView,
                          arguments: RequiredSocioIds(
                              uid: currSinglePost.userUid,
                              pstId: currSinglePost.postId),
                        ),
                        child: const Text("No commnts yet"),
                      )
                    : InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.commentView,
                          arguments: RequiredSocioIds(
                              uid: currSinglePost.userUid,
                              pstId: currSinglePost.postId),
                        ),
                        child: Text(
                            "View all ${currSinglePost.totalComments} comments"),
                      ),

                SizedBox(height: 10.w),
                Divider(
                  height: 1.2.h,
                ),
                // SizedBox(height: 5.w),
              ],
            ),
          );
        }
        return const Center(
          child: AppLoader(),
        );
      }),
    );
  }

  delPost() {
    BlocProvider.of<PostCubit>(context).deletePost(
      delPost: PostEntity(
        postId: widget.postId,
        // userUid: widget.userUid,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post Deleted."),
      ),
    );
  }

  likePost() {
    BlocProvider.of<PostCubit>(context).likePost(
      likePost: PostEntity(
        postId: widget.postId,
        // userUid: widget.userUid,
      ),
    );
  }

  openBottomSheet(BuildContext context, PostEntity postEntity) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BottomSheetAppBar(
              // title: "Manage Account",
              isDivider: true,
              haveCloseIcon: false,
              rowAxisAlignment: MainAxisAlignment.start,
              colCrossAxisAlignment: CrossAxisAlignment.start,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Text("More Options"),
                  // ),
                  // Container(height: 1.h, color: AppColor.monoGrey3),
                  TextButton(
                    onPressed: () => delPost(),
                    child: const Text("Delete Post"),
                  ),
                  // Container(height: 1.h, color: AppColor.monoGrey3),
                  TextButton(
                    onPressed: () => Navigator.popAndPushNamed(
                      context,
                      Routes.editPost,
                      arguments: postEntity,
                    ),
                    // Nav.popAndPushNamed(Routes.editPost),
                    child: const Text("Edit Post"),
                  ),
                  SizedBox(height: 15.h),
                ],
              )
              // : GestureDetector(
              //     onTap: () {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text(
              //             "Thanks for reporting. We will let you know if this post is inappropriate.",
              //           ),
              //         ),
              //       );
              //     },
              //     child: const Text("Report post")),
              // closeIcon: FaIcon(
              //   FontAwesomeIcons.close,
              //   size: 17.w,
              // ),
              ),
        ),
      );
}
