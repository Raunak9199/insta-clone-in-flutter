import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socio_chat/dep_inj/export.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/global-widgets/app_bottom_sheet.dart';

class HomeController {
  delPost({context, postId, userUid}) {
    BlocProvider.of<PostCubit>(context).deletePost(
      delPost: PostEntity(
        postId: postId,
        userUid: userUid,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post Deleted."),
      ),
    );
  }

  likePost({context, postId, userUid}) {
    BlocProvider.of<PostCubit>(context).likePost(
      likePost: PostEntity(
        postId: postId,
        userUid: userUid,
      ),
    );
  }

  openBottomSheet({context, postEntity, void Function()? delete}) =>
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
              body: InkWell(
                highlightColor: AppColor.secondaryDark.withOpacity(0.3),
                onTap: delete,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 5.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.trash,
                        size: 20.w,
                        color: AppColor.secondaryDark,
                      ),
                      SizedBox(width: 15.w),
                      const Text("Delete Post"),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              )),
        ),
      );

  downloadMethod(
      BuildContext context, PostEntity postEntity, String? userName) async {
    final provider = BlocProvider.of<DownloadCubitCubit>(context);
    await provider.downloadPostImage(
        postEntity: postEntity, imageName: userName ?? postEntity.userUid!);
  }
}

/*   delPost() {
    BlocProvider.of<PostCubit>(context).deletePost(
      delPost: PostEntity(
        postId: widget.postEntity.postId,
        userUid: widget.postEntity.userUid,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post Deleted."),
      ),
    );
  } */

  /* likePost() {
    BlocProvider.of<PostCubit>(context).likePost(
      likePost: PostEntity(
        postId: widget.postEntity.postId,
        userUid: widget.postEntity.userUid,
      ),
    );
  } */

  /* disLikePost() {
    BlocProvider.of<PostCubit>(context).disLikePost(
      disLikePost: PostEntity(
        postId: widget.postEntity.postId,
        userUid: widget.postEntity.userUid,
      ),
    );
  } */
