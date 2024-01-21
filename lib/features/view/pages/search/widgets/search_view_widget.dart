import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/cubit/user/user_cubit.dart';
import 'package:socio_chat/features/view/pages/search/widgets/filtered_search_results.dart';
import 'package:socio_chat/features/view/pages/search/widgets/search_bar_widget.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';

class SearchPageWidget extends StatefulWidget {
  const SearchPageWidget({super.key});

  @override
  State<SearchPageWidget> createState() => _SearchPageWidgetState();
}

class _SearchPageWidgetState extends State<SearchPageWidget> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUsers(user: const UserEntity());
    BlocProvider.of<PostCubit>(context)
        .fetchAndDisplayPostss(post: const PostEntity());
    searchController.addListener(() {
      // setState(() {});
      update();
    });
    super.initState();
  }

  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColor.backgroundColor,
      body: BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
        if (userState is UserLoaded) {
          // Get the filtered users in [searchUsers]
          final searchUsers = userState.users.where((user) {
            // Get the text from textfield
            final searchQuery = searchController.text.toLowerCase();
            // Check for username or name
            final userName = user.userName?.toLowerCase() ?? '';
            final name = user.name?.toLowerCase() ?? '';
            // Match the username or name with database
            final usrName = userName.startsWith(searchQuery) ||
                userName.contains(searchQuery);
            final nme =
                name.startsWith(searchQuery) || name.contains(searchQuery);
            return usrName || nme;
          }).toList();

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h)
                  .copyWith(top: 10.h),
              child: Column(
                children: [
                  // Search TextField
                  SearchBarWidget(
                    searchUsers: searchUsers,
                    searchController: searchController,
                  ),
                  SizedBox(height: 15.h),
                  if (searchController.text.isNotEmpty)
                    // Display searched results
                    FilteredSearchResults(searchUsers: searchUsers)
                  else
                    const Center(
                      child: Text("Search for users."),
                    ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: AppLoader(),
        );
      }),
    );
  }
}
