import 'package:flutter/material.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';

class FilteredSearchResults extends StatelessWidget {
  const FilteredSearchResults({
    super.key,
    required this.searchUsers,
  });

  final List<UserEntity> searchUsers;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: searchUsers.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.usersProfilePageView,
              arguments: searchUsers[index].uid,
            );
          },
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      ImageDisplayWidget(imgUrl: searchUsers[index].profileUrl),
                ),
              ),
              SizedBox(width: 10.h),
              Text(
                "${searchUsers[index].userName}",
                style: const TextStyle(
                  color: AppColor.secondaryDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
