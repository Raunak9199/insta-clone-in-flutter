import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_draggable_widget/flutter_draggable_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/home/widgets/list_post_widget.dart';
import 'package:socio_chat/features/view/pages/home/widgets/msg_btn.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';
import 'package:socio_chat/global-widgets/app_image.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double topPosition = 20;
  double leftPosition = 20;
  final dragController = DragController();
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

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  // To retain the scroll state where user
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppScaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppNewAppBar(
        params: AppAppBarModel(
          backgroundColor: Colors.black,
          elevation: 0.2,
          // title: 'Socio',
          titleInWidget: const AppImage("assets/logo.png"),
          titleStyle: Get.textTheme.headlineSmall!.copyWith(
            color: AppColor.monoAlt,
          ),
        ),
      ),
      floatingActionButton: MessageButton(
        icon: FontAwesomeIcons.facebookMessenger,
        onPressed: () => Navigator.pushNamed(context, Routes.globalChatRoom),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Stack(
        children: [
          BlocProvider<PostCubit>(
            create: (context) => inj.sl<PostCubit>()
              ..fetchAndDisplayPostss(post: const PostEntity()),
            child: BlocBuilder<PostCubit, PostState>(
                builder: (context, postState) {
              if (postState is PostLoaded) {
                dragController.showWidget();
                return postState.posts.isEmpty
                    ? const Center(
                        child:
                            Text("No Posts yet. Be the first one to create!!"),
                      )
                    : ListPostWidget(postState: postState);
              }
              if (postState is PostLoading) {
                return const Center(
                  child: AppLoader(),
                );
              }
              if (postState is PostFailure) {
                return const Center(
                  child: Text(
                    "Oops! Some error occured.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              /* if(postState is PostLoaded){
                if(postState.posts.length == postState.posts.length-1){
                  return const Center(
                child: AppLoader(),
              );
                }
              } */
              return const Center(
                child: AppLoader(),
              );
            }),
          ),
          /* FlutterDraggableWidget(
            initialPosition: AnchoringPosition.bottomRight,
            intialVisibility: true,
            shadowBorderRadius: 50,
            
            child: messageButton(
              icon: FontAwesomeIcons.facebookMessenger,
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.globalChatRoom),
            ),
          ), */
        ],
      ),
    );
  }

/*   Widget messageButton({
    required IconData icon,
    required void Function()? onPressed,
  }) {
    return MessageButton();
  } */
}




/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_gerate_rute.dart';
import 'package:socio_chat/cubit/user/single_user/single_user_cubit.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_bottom_sheet.dart';
import 'package:socio_chat/global-widgets/app_image.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/global-widgets/bottom-nav/bottom_nav_bar_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.uid});
  final String uid;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BottomNavBarController controller = Get.put(BottomNavBarController());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoggedInCurrentUserCubit, LoggedInuserState>(
      builder: (context, state) {
        if (state is SingleUserLoaded) {
          final currentUser = state.user;

          return AppScaffold(
            // scaffoldKey: controller.rootScaffoldKey,
            onWillPop: controller.rootOnWillPop,
            appBar: AppNewAppBar(
              params: AppAppBarModel(
                backgroundColor: AppColor.backgroundColor,
                elevation: 2,
                // title: 'Socio',
                titleInWidget: const AppImage("assets/logo.png"),
                titleStyle: Get.textTheme.headlineSmall!.copyWith(
                  color: AppColor.monoAlt,
                ),
                actions: [
                  IconButton(
                    tooltip: "Add a post.",
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.addPost),
                    //  Nav.pushNamed(Routes.addPost),
                    icon: const Icon(
                      Icons.add,
                      color: AppColor.monoAlt,
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30.h,
                            width: 30.h,
                            decoration: const BoxDecoration(
                              color: AppColor.secondaryClr,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "UserName",
                            style: Get.textTheme.bodyMedium,
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: BottomSheetAppBar(
                              // title: "Manage Account",
                              isDivider: true,
                              haveCloseIcon: false,
                              rowAxisAlignment: MainAxisAlignment.start,
                              colCrossAxisAlignment: CrossAxisAlignment.start,
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // TextButton(
                                  //   onPressed: () {},
                                  //   child: Text("More Options"),
                                  // ),
                                  // Container(height: 1.h, color: AppColor.monoGrey3),
                                  TextButton(
                                    onPressed: () => Navigator.popAndPushNamed(
                                        context, Routes.editProfileView),
                                    // Nav.popAndPushNamed(Routes.editProfileView),
                                    child: const Text("Delete Post"),
                                  ),
                                  // Container(height: 1.h, color: AppColor.monoGrey3),
                                  TextButton(
                                    onPressed: () => Navigator.popAndPushNamed(
                                        context, Routes.editPost),
                                    // Nav.popAndPushNamed(Routes.editPost),
                                    child: const Text("Edit Post"),
                                  ),
                                  SizedBox(height: 15.h),
                                ],
                              ),
                              // closeIcon: FaIcon(
                              //   FontAwesomeIcons.close,
                              //   size: 17.w,
                              // ),
                            ),
                          ),
                        ),
                        child: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 300.h,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColor.secondaryClr,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.thumb_up_alt_outlined,
                        color: AppColor.monoAlt,
                      ),
                      SizedBox(width: 12.w),
                      const Icon(
                        Icons.thumb_down_alt_outlined,
                        color: AppColor.monoAlt,
                      ),
                      SizedBox(width: 12.w),
                      InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.commentView),
                        child: FaIcon(
                          FontAwesomeIcons.comment,
                          color: AppColor.monoAlt,
                          size: 22.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      FaIcon(
                        FontAwesomeIcons.paperPlane,
                        color: AppColor.monoAlt,
                        size: 22.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.w),
                  Text(
                    "Caption",
                    style: Get.textTheme.bodyMedium!
                        .copyWith(color: AppColor.secondaryClr),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: AppLoader(),
        );
      },
    );
  }
}
 */
