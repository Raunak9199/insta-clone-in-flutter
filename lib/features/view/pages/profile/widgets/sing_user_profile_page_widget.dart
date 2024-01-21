import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_curr_uid_usecase.dart';
import 'package:socio_chat/cubit/auth/auth_cubit.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/cubit/user/other_single_user.dart/other_single_user_dart_cubit.dart';
import 'package:socio_chat/cubit/user/user_cubit.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_elevated_button.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class UsersProfilePageViewWidget extends StatefulWidget {
  // final UserEntity currentUser;

  final String otherUserId;
  const UsersProfilePageViewWidget({Key? key, required this.otherUserId})
      : super(key: key);

  @override
  State<UsersProfilePageViewWidget> createState() =>
      _UsersProfilePageViewWidgetState();
}

class _UsersProfilePageViewWidgetState
    extends State<UsersProfilePageViewWidget> {
  String currentUid = "";
  refreshPosts() {
    BlocProvider.of<PostCubit>(context)
        .fetchAndDisplayPostss(post: const PostEntity());
  }

  @override
  void initState() {
    BlocProvider.of<OtherSingleUserDartCubit>(context)
        .fetchEveryOtherUser(otherUid: widget.otherUserId);
    // BlocProvider.of<PostCubit>(context).fetchAndDisplayPostss(post: const PostEntity());
    refreshPosts();
    super.initState();

    inj.sl<GetCurrentUserUidUseCase>().call().then((value) {
      setState(() {
        currentUid = value;
      });
    });
  }

  ab() {}
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherSingleUserDartCubit, OtherSingleUserDartState>(
        builder: (context, currentuserState) {
      if (currentuserState is OtherSingleUserDartLoaded) {
        final currSingUser = currentuserState.otherUser;
        return Scaffold(
          backgroundColor: AppColor.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColor.backgroundColor,
            elevation: 0.4,
            title: const Text(
              "Socio",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: RefreshIndicator(
            onRefresh: () => refreshPosts(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: SingleChildScrollView(
                child: RefreshIndicator(
                  onRefresh: () {
                    return ab();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${currSingUser.userName}",
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  color: AppColor.monoDark,
                                  fontSize: 24.sp,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "${currSingUser.name == "" ? currSingUser.userName : currSingUser.name}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.displayFullImage,
                                arguments: currSingUser),
                            child: Hero(
                              tag: "user-prof",
                              child: SizedBox(
                                height: 80.w,
                                width: 80.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: ImageDisplayWidget(
                                    imgUrl: currSingUser.profileUrl,
                                    // imgUrl: imageFile!.path,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "${currSingUser.about}",
                        style: const TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 10.h),
                      //
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "${currSingUser.totalPosts}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.h),
                              const Text(
                                "Posts",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          SizedBox(width: 25.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.connectionsPage,
                                arguments: currSingUser,
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${currSingUser.totalConnections}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.h),
                                const Text(
                                  "Connectons",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 25.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.friendsPage,
                                arguments: currSingUser,
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${currSingUser.totalFriends}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.h),
                                const Text(
                                  "Friends",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Check for owner then show icon
                          currSingUser.uid == currentUid
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: InkWell(
                                    onTap: () {
                                      _openBottomModalSheet(
                                          context, currSingUser);
                                    },
                                    child: const Icon(
                                      Icons.settings,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),

                      SizedBox(height: 15.h),

                      //
                      currSingUser.uid == currentUid
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: AppElevatedButton(
                                width: double.maxFinite,
                                height: 42.h,
                                title: currSingUser.connections!
                                        .contains(currentUid)
                                    ? "Remove Friend"
                                    : "Add as a Friend",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                isValid: true,
                                isLoading: isLoading,
                                onPressed: follow,
                                color: currSingUser.connections!
                                        .contains(currentUid)
                                    ? AppColor.darkBackgroundClr
                                        .withOpacity(0.5)
                                    : AppColor.secondaryDark,
                              ),
                            ),

                      //

                      SizedBox(height: 15.h),
                      BlocBuilder<PostCubit, PostState>(
                        builder: (context, postState) {
                          if (postState is PostLoaded) {
                            final posts = postState.posts
                                .where((post) =>
                                    post.userUid == widget.otherUserId)
                                .toList();
                            return GridView.builder(
                                itemCount: posts.length,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.9,
                                  crossAxisSpacing: 8.w,
                                  mainAxisSpacing: 8.h,
                                ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // TODO
                                      // Navigator.pushNamed(
                                      //   context,
                                      //   Routes.postDetailPage,
                                      //   arguments: posts[index].postId,
                                      // );
                                    },
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ImageDisplayWidget(
                                          imgUrl: posts[index].postUrl),
                                    ),
                                  );
                                });
                          }
                          return const Center(
                            child: AppLoader(),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return const AppScaffold(body: Center(child: AppLoader()));
    });
  }

  bool isLoading = false;

  follow() {
    setState(() {
      isLoading = true;
    });
    BlocProvider.of<UserCubit>(context)
        .followUser(
            user: UserEntity(
      uid: currentUid,
      otherId: widget.otherUserId,
    ))
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _openBottomModalSheet(BuildContext context, UserEntity currSingUser) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            // height: ,
            decoration:
                BoxDecoration(color: AppColor.backgroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.h, top: 7.h),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.editProfileView,
                              arguments: currSingUser);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                        },
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                    const Divider(
                      thickness: 1,
                      color: AppColor.secondaryDark,
                    ),
                    SizedBox(height: 7.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: InkWell(
                        onTap: () {
                          BlocProvider.of<AuthCubit>(context).loggedOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.loginView, (route) => false);
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
