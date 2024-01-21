import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/req_socio_entities.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/features/view/pages/home/widgets/post_item_widget.dart';

class PostBottomButtons extends StatelessWidget {
  const PostBottomButtons({
    super.key,
    required this.widget,
    required this.cont,
    required this.currentUserUid,
  });

  final PostWidget widget;
  final Controller cont;
  final String currentUserUid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("${widget.postEntity.totalLike}"),
        GestureDetector(
          onTap: () => cont.likePst(context),
          child: Icon(
            widget.postEntity.likes!.contains(currentUserUid)
                ? Icons.thumb_up_alt
                : Icons.thumb_up_alt_outlined,
            color: widget.postEntity.likes!.contains(currentUserUid)
                ? AppColor.secondaryDark
                : AppColor.monoAlt,
          ),
        ),
        SizedBox(width: 12.w),
        Text("${widget.postEntity.totalComments}"),
        InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            Routes.commentView,
            arguments: RequiredSocioIds(
              pstId: widget.postEntity.postId,
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
        //  Download
      ],
    );
  }
}