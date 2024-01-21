import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/cubit/user/user_cubit.dart';

class EditProfileController {
    final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  // bool isLoading = false;
  update({context, user}) {
    FocusScope.of(context).requestFocus(FocusNode());

    isLoading.value = true;
    final provider = BlocProvider.of<UserCubit>(context);
    provider
        .updateUser(
      user: user,
      post: const PostEntity(),
    )
        .then((value) {
      isLoading.value = false;
      // nameController!.clear();
      // userNameController!.clear();
      // aboutController!.clear();
      Navigator.pop(context);
    });
  }
}
