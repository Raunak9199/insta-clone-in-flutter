import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/profile/profile_page_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;

  const ProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => inj.sl<PostCubit>(),
      child: ProfileMainWidget(
        currentUser: currentUser,
      ),
    );
  }
}
