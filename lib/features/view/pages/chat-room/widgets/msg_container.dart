import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/prof_pic_widget.dart';

class MsgContainer extends StatelessWidget {
  final String? uid;
  final String? name;
  final String? message;
  final String? time;
  final String? image;
  final Color? color;
  final TextAlign? align;
  final CrossAxisAlignment crossAxisAlignment;
  final String senderName;
  final String senderId;
  final MainAxisAlignment mainAxAlignment;
  final String? msgType;

  const MsgContainer({
    Key? key,
    required this.uid,
    this.message,
    this.time,
    this.image,
    this.name,
    this.color,
    this.align,
    required this.msgType,
    required this.crossAxisAlignment,
    required this.senderName,
    required this.senderId,
    required this.mainAxAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: mainAxAlignment,
            children: [
              uid != senderId
                  ? ProfilePicWidget(
                      imageurl: image,
                      height: 20.w,
                      width: 20.w,
                    )
                  : const SizedBox.shrink(),
              Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  color: color,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    uid != senderId && name != null
                        ? Text(
                            name ?? "Me",
                            textAlign: align,
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Text(
                            senderName,
                            textAlign: align,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                    SizedBox(height: 5.w),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Text(
                        message ?? "",
                        textAlign: align,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.w),
                      child: Text(
                        time ?? Timestamp.now().toString(),
                        textAlign: align,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    )
                  ],
                ),
              ),
              uid == senderId
                  ? ProfilePicWidget(
                      imageurl: image,
                      height: 20.w,
                      width: 20.w,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
