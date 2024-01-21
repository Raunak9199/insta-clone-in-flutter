import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/global-widgets/app_text_form_field.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.searchUsers,
    required this.searchController,
  });

  final List<UserEntity> searchUsers;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: AppTextFormField(
        height: 40.h,
        borderRad: 20.r,
        onChanged: (value) {
          searchUsers;
        },
        controller: searchController,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: AppColor.secondaryClr,
            size: 15.h,
          ),
        ),
        hintText: "Search",
      ),
    );
  }
}
