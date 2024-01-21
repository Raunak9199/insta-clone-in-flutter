import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/cubit/auth/auth_cubit.dart';
import 'package:socio_chat/cubit/cred/cred_cubit.dart';
import 'package:socio_chat/cubit/global-msg/download-cubit/download_cubit_cubit.dart';
import 'package:socio_chat/cubit/global-msg/global_message_cubit.dart';
import 'package:socio_chat/cubit/user/other_single_user.dart/other_single_user_dart_cubit.dart';
import 'package:socio_chat/cubit/user/single_user/single_user_cubit.dart';
import 'package:socio_chat/cubit/user/user_cubit.dart';
import 'package:socio_chat/features/view/pages/auth/login_page.dart';
import 'package:socio_chat/global-widgets/bottom-nav/bottom_nav_index_pages.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
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
          }
        },
      );

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SimpleBuilder(builder: (context) {
        return ScreenUtilInit(
          designSize: const Size(360, 779),
          minTextAdapt: true,
          builder: (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => inj.sl<AuthCubit>()..appStarted()),
              BlocProvider(create: (_) => inj.sl<UserCubit>()),
              // child: GlobalChatView(user: UserEntity()),
              BlocProvider(create: (_) => inj.sl<CredCubit>()),
              BlocProvider(create: (context) => inj.sl<GlobalMessageCubit>()),
              BlocProvider(create: (_) => inj.sl<LoggedInCurrentUserCubit>()),
              BlocProvider(create: (_) => inj.sl<OtherSingleUserDartCubit>()),
              BlocProvider(create: (_) => inj.sl<DownloadCubitCubit>()),
              // BlocProvider<GlobalMessageCubit>(
              //     create: (_) => inj.sl<GlobalMessageCubit>()),
            ],
            child: GetMaterialApp(
              locale: const Locale('en', 'US'),
              fallbackLocale: const Locale('en', 'US'),
              darkTheme: ThemeData.dark(),
              // theme: ThemeData(),
              debugShowCheckedModeBanner: false,
              title: "Socio",
              initialRoute: '/',
              onGenerateRoute: OnGenerateRoute.route,
              routes: {
                "/": (context) {
                  return BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthenticatedState) {
                        return BottomNavIndexPage(uid: state.uid);
                      } else {
                        return const LoginPage();
                      }
                    },
                  );
                },
              },
            ),
          ),
        );
      });

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity.'),
          actions: <Widget>[
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
  showJailBreakDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Rooted!'),
          content: const Text('Can\'t proceed. Your phone is rooted!'),
          actions: <Widget>[
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
}
