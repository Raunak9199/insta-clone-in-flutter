import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';

class AppCustomAnimatedBottomBar extends StatelessWidget {
  const AppCustomAnimatedBottomBar({
    Key? key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.cornerRadius = 50,
    this.containerHeight = 56,
    // this.animationDuration = const Duration(milliseconds: 200),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  })  : assert(items.length >= 2 && items.length <= 5),
        super(key: key);

  final int selectedIndex;
  final double iconSize;
  final Color? backgroundColor;
  final bool showElevation;
  // final Duration animationDuration;
  final List<BottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double cornerRadius;
  final double containerHeight;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final darkBackgroundClr =
        backgroundColor ?? Theme.of(context).bottomAppBarColor;

    return Container(
      decoration: BoxDecoration(
        color: darkBackgroundClr,
        boxShadow: [
          if (showElevation)
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.r,
            ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: containerHeight,
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: items.map((item) {
              var index = items.indexOf(item);
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: _ItemWidget(
                  item: item,
                  iconSize: iconSize,
                  isSelected: index == selectedIndex,
                  backgroundColor: darkBackgroundClr,
                  itemCornerRadius: cornerRadius,
                  // animationDuration: animationDuration,
                  // curve: curve,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  // final Duration animationDuration;
  // final Curve curve;

  const _ItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    // required this.animationDuration,
    required this.itemCornerRadius,
    required this.iconSize,
    // this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: SizedBox(
        width: 67.w,
        height: isSelected ? 44.h : 44.h,
        // duration: animationDuration,
        // curve: curve,
        child: Container(
          width: 85.w,
          height: isSelected ? 44.h : 44.h,
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                  size: iconSize,
                  color: isSelected
                      ? item.activeColor
                      : item.inactiveColor ?? AppColor.monoLight,
                ),
                child: item.icon,
              ),
              // if (isSelected)
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: DefaultTextStyle.merge(
                    style: Get.textTheme.bodySmall!.copyWith(
                      color: isSelected
                          ? item.activeColor
                          : item.inactiveColor ?? AppColor.monoLight,
                    ),
                    maxLines: 1,
                    textAlign: item.textAlign,
                    child: item.title,
                  ),
                ),
              ),
            ],
          ),
        ),
        //   ),
      ),
    );
  }
}

class BottomNavBarItem {
  BottomNavBarItem({
    required this.icon,
    required this.title,
    this.iconColor = AppColor.monoGrey3,
    this.activeColor = AppColor.secondaryDark,
    this.textAlign,
    this.inactiveColor,
  });

  final Widget icon;
  final Widget title;
  final Color? iconColor;
  final Color activeColor;
  final Color? inactiveColor;
  final TextAlign? textAlign;
}
