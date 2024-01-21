import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/add-post/widgets/upload_post_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class AddPost extends StatelessWidget {
  final UserEntity currentUser;
  const AddPost({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCubit>.value(
          value: inj.sl<PostCubit>(),
        ),
      ],
      child: UploadPostWidget(
        currentUser: currentUser,
      ),
    );
  }
}
