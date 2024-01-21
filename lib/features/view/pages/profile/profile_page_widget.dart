import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/app_navigation.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/profile/controllers/profile_page_controller.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';
import 'package:socio_chat/global-widgets/app_elevated_button.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserEntity currentUser;

  const ProfileMainWidget({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  late ProfilePageController _controller;
  late _Controller profController;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          } else {
            setState(() {
              isAlertSet = false;
            });
          }
        },
      );
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Connectivity'),
          content:
              const Text('Please make sure you have an internet connection.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                bool? shouldClose = await openAppDialog(
                  context: context,
                  params: OpenDialogModel(
                    title: "Exit app?",
                    isDismissible: true,
                    subTitle: "Are you sure, you want to exit the app?".tr,
                  ),
                );

                return Future.value(shouldClose ?? false);
              },
              child: const Text("Exit"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  // final getIt = GetIt.instance;
  refreshPosts() {
    BlocProvider.of<PostCubit>(context)
        .fetchAndDisplayPostss(post: const PostEntity());
  }

  @override
  void initState() {
    getConnectivity();
    BlocProvider.of<PostCubit>(context)
        .fetchAndDisplayPostss(post: const PostEntity());
    refreshPosts();
    _controller = ProfilePageController(
      context,
      widget.currentUser,
      () => setState(() {}),
    );
    profController = _Controller(this, widget.currentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppNewAppBar(
          params: AppAppBarModel(
            backgroundColor: AppColor.backgroundColor,
            elevation: 0.4,
            titleInWidget: Text(
              "${widget.currentUser.userName}",
              style: Get.textTheme.bodyMedium!.copyWith(
                color: AppColor.monoDark,
                fontSize: 24.sp,
              ),
              softWrap: true,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "${widget.currentUser.name == "" ? widget.currentUser.userName : widget.currentUser.name}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: 180.w,
                          child: Text(
                            "${widget.currentUser.about}",
                            style: const TextStyle(color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => openProfileDialog(),
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag: "user-prof",
                        child: SizedBox(
                          height: 80.w,
                          width: 80.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: _controller.isLoading.value
                                ? const Center(
                                    child: AppLoader(),
                                  )
                                : ImageDisplayWidget(
                                    imgUrl: widget.currentUser.profileUrl!,
                                    // imgUrl: imageFile!.path,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                //
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          (widget.currentUser.totalPosts! <= 0)
                              ? "0"
                              : "${widget.currentUser.totalPosts}",
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        const Text(
                          "Posts",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(width: 25.w),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      focusColor: AppColor.secondaryDark.withOpacity(0.2),
                      highlightColor: AppColor.secondaryDark.withOpacity(0.2),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.connectionsPage,
                          arguments: widget.currentUser,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.w),
                        child: Column(
                          children: [
                            Text(
                              (widget.currentUser.totalConnections! <= 0)
                                  ? "0"
                                  : "${widget.currentUser.totalConnections}",
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
                    ),
                    SizedBox(width: 25.w),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      focusColor: AppColor.secondaryDark.withOpacity(0.2),
                      highlightColor: AppColor.secondaryDark.withOpacity(0.2),
                      onTap: () => Navigator.pushNamed(
                          context, Routes.friendsPage,
                          arguments: widget.currentUser),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.w),
                        child: Column(
                          children: [
                            Text(
                              (widget.currentUser.totalFriends! <= 0)
                                  ? "0"
                                  : "${widget.currentUser.totalFriends}",
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
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: InkWell(
                        onTap: () {
                          _controller.openBottomModalSheet();
                        },
                        child: const Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),

                //

                SizedBox(height: 10.h),
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, postState) {
                    if (postState is PostLoaded) {
                      final posts = postState.posts
                          .where(
                              (post) => post.userUid == widget.currentUser.uid)
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
                              // onTap: () => Navigator.pushNamed(
                              //   context,
                              //   Routes.displayFullImage,
                              //   arguments: widget.currentUser,
                              // ),
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
        ));
  }

  openProfileDialog() {
    return showModalBottomSheet(
        useSafeArea: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 90.h,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppElevatedButton(
                  title: "View Profile",
                  isValid: true,
                  color: AppColor.secondaryDark,
                  width: MediaQuery.of(context).size.width * 0.4,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.displayFullImage,
                    arguments: widget.currentUser,
                  ),
                ),
                AppElevatedButton(
                  title: "Change Profile",
                  isValid: true,
                  color: AppColor.secondaryDark,
                  width: MediaQuery.of(context).size.width * 0.4,
                  onPressed: () => chooseImage(),
                ),
              ],
            ),
          );
        });
  }

  void render(fn) => setState(fn);
  final ImagePicker _picker = ImagePicker();
  final imageSource = ImageSource.gallery;

  Future<void> chooseImage() async {
    Nav.pop();
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      render(() {
        if (pickedFile != null) {
          _controller.imageFile = File(
            pickedFile.path,
          );
          openConfirmationDialog();
          // profController.updateImage();
          // var pop = Navigator.canPop(context);
          // pop ? Navigator.pop(context) : null;
        } else {
          Nav.pop();
          NewAppSnackBar.showSnackbar(
            msg: 'No file selected to upload.',
            title: 'OOps!!',
          );

          log("No file selected to upload");
        }
      });
    } catch (e) {
      AppErrorSnackBar.showSnackbar(msg: "$e.", title: "Error!!");
    }
  }

  openConfirmationDialog() {
    return openAppDialog(
      context: context,
      params: OpenDialogModel(
        title: "Upload??".tr,

        onConfirm: () {
          profController.updateImage();
          var pop = Navigator.canPop(context);
          pop ? Navigator.pop(context) : null;
        },
        onCancel: () => Nav.pop(),
        // onConfirm: () async => AuthUtils.clearData(),
      ),
    );
  }
}

class _Controller {
  _ProfileMainWidgetState state;
  UserEntity userEntity;
  _Controller(this.state, this.userEntity);

  updateImage() {
    state.render(() => state._controller.updateUserData());
  }

  // chooseImage() {
  //   state.render(() => state.chooseImage());
  // }
}
