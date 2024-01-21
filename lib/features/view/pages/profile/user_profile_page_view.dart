import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/cubit/user/single_user/single_user_cubit.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/sing_user_profile_page_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class UserProfilePageView extends StatelessWidget {
  final String otherUserId;
  const UserProfilePageView({super.key, required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoggedInCurrentUserCubit>(
          create: (context) => inj.sl<LoggedInCurrentUserCubit>(),
        ),
        BlocProvider<PostCubit>(
          create: (context) => inj.sl<PostCubit>(),
        ),
      ],
      child: UsersProfilePageViewWidget(otherUserId: otherUserId),
    );
  }
}
