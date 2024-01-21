import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';

class CommentFieldWidget extends StatelessWidget {
  const CommentFieldWidget({
    super.key,
    required this.isRepl,
    required this.commentController,
  });

  final bool isRepl;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        autofocus: isRepl,
        style: Get.textTheme.bodyLarge!.copyWith(
          color: AppColor.monoAlt.withOpacity(0.9),
        ),
        controller: commentController,
        // onChanged: checkDisabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Add a comment...",
          filled: true,
          fillColor: Colors.white,
          hintStyle: Get.textTheme.bodyLarge!.copyWith(
            color: AppColor.monoGrey3,
          ),
        ),
      ),
    );
  }
}
