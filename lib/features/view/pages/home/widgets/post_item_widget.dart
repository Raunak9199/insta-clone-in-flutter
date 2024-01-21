import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/req_socio_entities.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_curr_uid_usecase.dart';
import 'package:socio_chat/features/view/pages/home/controllers/home_controller.dart';
import 'package:socio_chat/features/view/pages/home/widgets/display_post_widget.dart';
import 'package:socio_chat/features/view/pages/home/widgets/post_bottom_btns_widget.dart';
import 'package:socio_chat/features/view/pages/home/widgets/post_header_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class PostWidget extends StatefulWidget {
  final PostEntity postEntity;
  const PostWidget({
    super.key,
    required this.postEntity,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  bool isAnimating = false;
  String currentUserUid = "";

  void render(fn) {
    setState(fn);
  }

  late HomeController homeController;
  late Controller cont;

  @override
  void initState() {
    inj.sl<GetCurrentUserUidUseCase>().call().then((uid) => setState(() {
          currentUserUid = uid;
        }));

    homeController = HomeController();
    cont = Controller(this, widget.postEntity);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<DownloadCubitCubit, DownloadCubitState>(
    //     builder: (context, state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PostHeader Info
          PostHeaderWidget(
            widget: widget,
            currentUserUid: currentUserUid,
            cont: cont,
          ),
          SizedBox(height: 10.h),
          // Post View
          DisplayPostWidget(widget: widget),

          SizedBox(height: 10.h),
          // Bottom Buttons
          PostBottomButtons(
            widget: widget,
            cont: cont,
            currentUserUid: currentUserUid,
          ),
          SizedBox(height: 12.w),
          widget.postEntity.desc!.isEmpty
              ? const SizedBox.shrink()
              : Text(
                  "${widget.postEntity.desc}",
                  style: Get.textTheme.bodyMedium!
                      .copyWith(color: AppColor.monoAlt),
                ),
          SizedBox(height: 10.w),
          widget.postEntity.totalComments == 0
              ? InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.commentView,
                    arguments: RequiredSocioIds(
                        uid: widget.postEntity.userUid,
                        pstId: widget.postEntity.postId),
                  ),
                  child: const Text("No comments yet"),
                )
              : InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.commentView,
                    arguments: RequiredSocioIds(
                        uid: widget.postEntity.userUid,
                        pstId: widget.postEntity.postId),
                  ),
                  child: Text(
                      "View all ${widget.postEntity.totalComments} comments"),
                ),

          SizedBox(height: 10.w),
          Divider(height: 1.2.h),
          // SizedBox(height: 5.w),
        ],
      ),
    );
    // });
  }
}

class Controller {
  final _PostWidgetState state;
  final PostEntity postEntity;
  Controller(this.state, this.postEntity);
/*   initialize() {
    state.render(() {
      state.homeController.postEntity = postEntity;
    });
  } */

  openSheet(context) {
    state.render(() {
      state.homeController.openBottomSheet(
        context: context,
        delete: () => deletePost(context),
        postEntity: postEntity,
      );
    });
  }

  likePost(context, postId, userUid) {
    state.render(() {
      state.homeController.likePost(
        context: context,
        postId: postId,
        userUid: userUid,
      );
    });
  }

  likePst(context) {
    state.render(() {
      state.homeController.likePost(
        context: context,
        postId: postEntity.postId,
        userUid: postEntity.userUid,
      );
    });
  }

  deletePost(context) {
    state.render(() {
      state.homeController.delPost(
        context: context,
        postId: postEntity.postId,
        userUid: postEntity.userUid,
      );
    });
  }
}
 /* (state is DownloadCubitLoading)
                    ? Padding(
                        padding: EdgeInsets.all(12.w),
                        child: AppLoader(
                          value: state.progress,
                          valueColor: _colorAnimation,
                          color: Colors.blue,
                        ),
                      )
                    : (state is DownloadCubitLoaded)
                        ? Icon(
                            Icons.download_done,
                            size: 24.w,
                            color: Colors.green,
                          )
                        : IconButton(
                            onPressed: () async {
                              downloadMethod(context);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.download,
                              color: AppColor.monoAlt,
                              size: 22.w,
                            ),
                          ), */
              /*  InkWell(
                  onTap: () {
                    //
                  },
                  child: FaIcon(
                    FontAwesomeIcons.download,
                    color: AppColor.monoAlt,
                    size: 22.w,
                  ),
                ), */