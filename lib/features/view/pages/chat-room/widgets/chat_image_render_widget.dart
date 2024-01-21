import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:socio_chat/cubit/global-msg/global_message_cubit.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/global_chat_view.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/prof_pic_widget.dart';

class ChatImageRenderWidget extends StatelessWidget {
  const ChatImageRenderWidget({
    super.key,
    required this.context,
    required this.lastIndex,
    required this.msgIndex,
    required this.msg,
    required this.widget,
    required this.senderImageUrl,
  });

  final BuildContext context;
  final GlobalMessageLoaded msg;
  final int lastIndex;
  final int msgIndex;
  final GlobalChatView widget;
  final String senderImageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.user.uid != msg.message[msgIndex].senderId
            ? Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: ProfilePicWidget(
                  imageurl: senderImageUrl,
                  height: 20.w,
                  width: 20.w,
                ),
              )
            : const SizedBox.shrink(),
        widget.user.uid != msg.message[msgIndex].senderId
            ? SizedBox(width: 5.w)
            : SizedBox(width: 0.w),
        imageRender(),
        widget.user.uid == msg.message[msgIndex].senderId
            ? SizedBox(width: 5.w)
            : SizedBox(width: 0.w),
        widget.user.uid == msg.message[msgIndex].senderId
            ? ProfilePicWidget(
                imageurl: senderImageUrl,
                height: 20.w,
                width: 20.w,
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  imageRender() {
    return Column(
      crossAxisAlignment: widget.user.uid != msg.message[msgIndex].senderId
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w).copyWith(
              left: widget.user.uid == msg.message[msgIndex].senderId
                  ? MediaQuery.of(context).size.width * 0.25
                  : 0.w,
              right: widget.user.uid != msg.message[msgIndex].senderId
                  ? MediaQuery.of(context).size.width * 0.25
                  : 0.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
              child: ImageDisplayWidget(
                height: 300.h,
                width: MediaQuery.of(context).size.width * 0.65,
                imgUrl: msg.message[msgIndex].chatImgFile,
              ),
            ),
          ),
        ),
        Text(
          DateFormat('hh:mm a').format(msg.message[msgIndex].msgTime!.toDate()),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        lastIndex == msg.message.length - 1
            ? SizedBox(height: 8.h)
            : const SizedBox.shrink(),
      ],
    );
  }
}
