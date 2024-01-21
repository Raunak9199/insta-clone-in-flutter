import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/utils/utils.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.errorText,
    this.inputFormatters,
    this.focusNode,
    this.nextFocusNode,
    this.contentPadding,
    this.onChanged,
    this.onTap,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.focusedBorder,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
    this.errorBorderColor,
    this.maxLength,
    this.autoFocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.isRequired = false,
    this.isShowLengthCount = false,
    this.errorTextStyle,
    this.initialValue,
    this.hintText,
    this.scrollPadding,
    this.suffixIconConstraints,
    this.margin,
    this.inputTextStyle,
    this.prefixIconPadding,
    this.suffixIconPadding,
    this.headingAndTextFieldGapHeight,
    this.textFieldBottomHeight,
    this.heading,
    this.onEditingComplete,
    // this.isInvalid = false,
    this.errMsg,
    this.length = '0',
    this.fillColor = AppColor.monoWhite,
    this.borderColor,
    this.labelStyle,
    this.showBorder = true,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.filled = false,
    this.height,
    this.obscureText,
    this.borderRad,
  });

  final TextEditingController? controller;
  final double? borderRad;
  final String? hintText;
  final String? initialValue;
  final String? labelText;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final Color? errorBorderColor;
  final Color? borderColor;
  final Color fillColor;
  final InputBorder? focusedBorder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final bool autoFocus;
  final bool readOnly;
  final bool enabled;
  final bool isRequired;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextStyle? errorTextStyle;
  final EdgeInsets? scrollPadding;
  final BoxConstraints? suffixIconConstraints;
  final EdgeInsetsGeometry? margin;
  final TextStyle? inputTextStyle;
  final TextStyle? labelStyle;
  final EdgeInsets? prefixIconPadding;
  final EdgeInsets? suffixIconPadding;
  final double? headingAndTextFieldGapHeight;
  final double? textFieldBottomHeight;
  final String? heading;
  final String? length;
  final String? errMsg;
  // final bool isInvalid;
  final bool isShowLengthCount;
  final bool showBorder;
  final bool filled;
  final bool expands;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: heading?.isNotEmpty ?? false,
              child: Text(
                heading ?? '',
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: AppColor.monoEmphasis),
              ),
            ),
            SizedBox(height: headingAndTextFieldGapHeight ?? 10.h),
            Container(
              // height: 48.h,
              // padding: EdgeInsets.symmetric(horizontal: 1.w),
              padding: EdgeInsets.only(bottom: 4.h),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(borderRad ?? 200.r),
                border: showBorder
                    ? Border.all(
                        color: (errMsg?.isNotEmpty ?? false)
                            ? AppColor.secondaryDark
                            : borderColor ?? AppColor.monoExtraLight,
                      )
                    : null,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height ?? 48.h,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: prefixIconPadding ?? EdgeInsets.zero,
                      child: prefix ?? SizedBox(width: 1.w),
                    ),
                    Expanded(
                      child: TextFormField(
                        scrollPadding:
                            scrollPadding ?? const EdgeInsets.all(20.0),
                        initialValue: initialValue,
                        focusNode: focusNode,
                        obscureText: obscureText ?? false,
                        expands: expands,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(nextFocusNode),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textAlignVertical: TextAlignVertical.center,
                        textCapitalization: textCapitalization,
                        textInputAction: textInputAction,
                        maxLength: maxLength,
                        enableSuggestions: true,
                        onEditingComplete: onEditingComplete,
                        // maxLines: obscureText == true ? null : maxLines,
                        minLines: minLines,
                        inputFormatters: inputFormatters ??
                            (keyboardType == TextInputType.phone
                                ? AppUtils.phoneInputFormatters()
                                : (maxLength != null
                                    ? [
                                        LengthLimitingTextInputFormatter(
                                          maxLength,
                                        ),
                                      ]
                                    : null)),
                        keyboardType: keyboardType,
                        cursorColor: AppColor.monoExtraLight,
                        style: enabled
                            ? Get.textTheme.bodyMedium!
                                .copyWith(letterSpacing: 0)
                            : Get.textTheme.bodyMedium!.copyWith(
                                letterSpacing: 0,
                                color: AppColor.monoAlt,
                              ),
                        decoration: InputDecoration(
                          prefixIconConstraints:
                              BoxConstraints(maxHeight: 24.w),
                          suffixIconConstraints: suffixIconConstraints ??
                              BoxConstraints(maxWidth: 24.w, maxHeight: 24.w),
                          contentPadding: contentPadding ??
                              EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: prefixIcon != null && !showBorder
                                    ? 0.w
                                    : 10.w,
                              ),
                          fillColor: fillColor,
                          filled: filled,
                          hintStyle: Get.textTheme.bodyMedium!
                              .copyWith(color: AppColor.monoGrey3),
                          labelText: labelText,
                          alignLabelWithHint: true,
                          labelStyle: labelStyle,
                          hintText: hintText,
                          errorText: errorText,
                          prefixIcon: prefix == null ? prefixIcon : null,
                          suffixIcon: suffix == null
                              ? suffixIcon
                              : const SizedBox.shrink(),
                          border: showBorder
                              ? InputBorder.none
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                          errorBorder: InputBorder.none,
                          enabledBorder: showBorder
                              ? InputBorder.none
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                          // enabledBorder:  InputBorder.none,
                          focusedBorder: showBorder
                              ? InputBorder.none
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                          disabledBorder: showBorder
                              ? InputBorder.none
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                          focusedErrorBorder: showBorder
                              ? InputBorder.none
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                        ),
                        controller: controller,
                        onChanged: onChanged,
                        validator: validator,
                        autofocus: autoFocus,
                        readOnly: readOnly,
                        enabled: enabled,
                        onTap: onTap,
                      ),
                    ),
                    Padding(
                      padding: suffixIconPadding ?? EdgeInsets.zero,
                      child: suffix ??
                          SizedBox(
                            width: 22.w,
                            height: 10.h,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            if (isRequired) const AsterisksSymboll(),
            ErrorMsgWithCount(
              errMsg: errMsg,
              length: length,
              margin: margin,
              isShowLengthCount: isShowLengthCount,
              textFieldBottomHeight: textFieldBottomHeight,
            ),
          ],
        ),
      );
}

class ErrorMsgWithCount extends StatelessWidget {
  const ErrorMsgWithCount({
    super.key,
    this.errMsg,
    this.margin,
    this.validator,
    this.length = '0',
    this.isShowLengthCount = false,
    this.textFieldBottomHeight,
  });

  final EdgeInsetsGeometry? margin;
  final String? errMsg;
  final String? length;
  final bool isShowLengthCount;
  final double? textFieldBottomHeight;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final isVisible = (errMsg?.isNotEmpty ?? false) || isShowLengthCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isVisible,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              Container(
                margin: margin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: errMsg?.isNotEmpty ?? false,
                      child: Expanded(
                        child: Text(
                          errMsg ?? '',
                          style: Get.textTheme.bodySmall!.copyWith(
                            color: AppColor.secondaryDark,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Visibility(
                      visible: isShowLengthCount,
                      child: Text(
                        '$length/10',
                        style: Get.textTheme.bodySmall!.copyWith(
                          color: AppColor.monoDark,
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: textFieldBottomHeight ?? (isVisible ? 15.h : 0.h),
        ),
      ],
    );
  }
}

class AsterisksSymboll extends StatelessWidget {
  const AsterisksSymboll({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(right: 5.w),
            child: Text(
              '*',
              textAlign: TextAlign.right,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColor.secondaryDark,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      );
}
