import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';

class NoPage extends StatelessWidget {
  const NoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Text(
          "Sorry! No such page found.",
          style: TextStyle(
            color: AppColor.monoDark,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
