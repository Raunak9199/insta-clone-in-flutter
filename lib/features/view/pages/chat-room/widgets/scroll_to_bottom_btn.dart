import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/constants/colors.dart';

class ScrollToBottomButton extends StatelessWidget {
  const ScrollToBottomButton({
    super.key,
    required bool isScrolledUp,
    required ScrollController messageScrollController,
  })  : _isScrolledUp = isScrolledUp,
        _messageScrollController = messageScrollController;

  final bool _isScrolledUp;
  final ScrollController _messageScrollController;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isScrolledUp,
      child: InkWell(
        borderRadius: BorderRadius.circular(50.r),
        onTap: () {
          // Scroll to the bottom when the button is pressed
          _messageScrollController.animateTo(
            _messageScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          height: 40.w,
          width: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.secondaryDark.withOpacity(0.5),
          ),
          child: const Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
