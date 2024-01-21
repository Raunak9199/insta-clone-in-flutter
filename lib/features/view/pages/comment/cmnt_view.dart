import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/req_socio_entities.dart';
import 'package:socio_chat/cubit/comment/comment_cubit.dart';
import 'package:socio_chat/cubit/post/curr_post/current_post_cubit.dart';
import 'package:socio_chat/cubit/user/single_user/single_user_cubit.dart';
import 'package:socio_chat/features/view/pages/comment/comment_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class CommentView extends StatelessWidget {
  final RequiredSocioIds socioEntity;
  const CommentView({super.key, required this.socioEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(
          create: (context) => inj.sl<CommentCubit>(),
        ),
        BlocProvider<LoggedInCurrentUserCubit>(
          create: (context) => inj.sl<LoggedInCurrentUserCubit>(),
        ),
        BlocProvider<CurrentPostCubit>(
          create: (context) => inj.sl<CurrentPostCubit>(),
        ),
      ],
      child: CommentWidgetM(
        socioEntity: socioEntity,
      ),
    );
  }
}
