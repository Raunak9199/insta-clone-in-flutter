import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/features/view/pages/home/widgets/post_item_widget.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';

class DisplayPostWidget extends StatelessWidget {
  const DisplayPostWidget({
    super.key,
    required this.widget,
  });

  final PostWidget widget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: double.maxFinite,
          maxHeight: 420.h,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: ImageDisplayWidget(
            imgUrl: "${widget.postEntity.postUrl}",
          ),
        ),
      ),
    );
  }
}
