import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/cubit/user/single_user/single_user_cubit.dart';
import 'package:socio_chat/features/view/pages/add-post/add_post.dart';
import 'package:socio_chat/features/view/pages/home/home_page.dart';
import 'package:socio_chat/features/view/pages/profile/profile_page_view.dart';
import 'package:socio_chat/features/view/pages/search/search_view.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/global-widgets/bottom-nav/app_bottom_navigation.dart';

class BottomNavIndexPage extends StatefulWidget {
  final String uid;
  const BottomNavIndexPage({super.key, required this.uid});

  @override
  State<BottomNavIndexPage> createState() => _BottomNavIndexPageState();
}

class _BottomNavIndexPageState extends State<BottomNavIndexPage> {
  final mainScaffoldKey = GlobalKey<ScaffoldState>();
  // final BottomNavBarController controller = Get.put(BottomNavBarController());
  late PageController pageController;
  int currentIndex = 0;
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    pageController = PageController();
    BlocProvider.of<LoggedInCurrentUserCubit>(context)
        .getSingleUser(uid: widget.uid);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    if (mainScaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
      return Future.value(false);
    } else if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
        onPageChanged(currentIndex);
        pageController.jumpToPage(currentIndex);
      });
      return Future.value(false);
    } else {
      bool? shouldClose = await openAppDialog(
        context: context,
        params: OpenDialogModel(
          title: "Exit app?",
          isDismissible: true,
          subTitle: "Are you sure, you want to exit the app?".tr,
        ),
      );

      return Future.value(shouldClose ?? false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoggedInCurrentUserCubit, LoggedInuserState>(
      builder: (context, state) {
        if (state is LoggedInUserLoaded) {
          final currUser = state.user;
          final List<Widget> screens = [
            const HomeView(),
            const SearchPage(),
            AddPost(currentUser: currUser),
            ProfilePage(currentUser: currUser),
          ];
          return WillPopScope(
            onWillPop: onWillPop,
            child: AppScaffold(
              onWillPop: onWillPop,
              backgroundColor: AppColor.backgroundColor,
              scaffoldKey: mainScaffoldKey,
              body: PageStorage(
                bucket: PageStorageBucket(),
                child: PageView(
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  children: screens,
                ),
              ),
              bottomNavigationBar: BottomNavigationBarWidget(
                controller: pageController,
                index: currentIndex,
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

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({
    Key? key,
    required this.controller,
    required this.index,
  }) : super(key: key);
  final PageController controller;
  final int index;
  // final BottomNavBarController controller;

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
// late PageController controller ;
  @override
  void initState() {
    // widget.controller = PageController();
    super.initState();
  }

  void onTap(int index) {
    widget.controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return
        // Obx(
        //   () =>
        AppCustomAnimatedBottomBar(
      showElevation: false,
      backgroundColor: AppColor.monoWhite,

      selectedIndex: widget.index,
      containerHeight: 60.h,
      items: <BottomNavBarItem>[
        BottomNavBarItem(
            icon: Icon(Icons.home, size: 28.w), title: const Text("")),
        BottomNavBarItem(
            icon: Icon(Icons.search, size: 28.w), title: const Text("")),
        BottomNavBarItem(
            icon: Icon(Icons.add, size: 28.w), title: const Text("")),
        BottomNavBarItem(
            icon: Icon(Icons.person_2, size: 28.w), title: const Text("")),
      ],
      onItemSelected: onTap,
      // ),
    );
  }
}


/* class BottomNavIndexPage extends GetView<BottomNavBarController> {
  const BottomNavIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(

      // haveAppBar: controller.tabIndex.value == 0,
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
              onPressed: () async {
                Nav.pushNamed(Routes.addPost);
              },
              icon: const Icon(
                Icons.add,
                color: AppColor.monoAlt,
              ),
            ),
          ],
        ),
      ),
      drawer: const Drawer(
          //
          ),
      backgroundColor: AppColor.backgroundColor,
      bottomNavigationBar: BottomNavigationBarWidget(controller: controller),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (int index) => controller.changeTabIndex(index),
        children: [
          Obx(
            () => controller.screenList[controller.tabIndex.value],
          ),
        ],
      ),
    );
  }
} */