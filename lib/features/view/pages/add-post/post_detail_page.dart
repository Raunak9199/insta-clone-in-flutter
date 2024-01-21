import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socio_chat/cubit/post/curr_post/current_post_cubit.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/add-post/widgets/post_detail_page_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class PostDetailPage extends StatelessWidget {
  final String postId;
  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => inj.sl<CurrentPostCubit>(),
        ),
        BlocProvider(
          create: (context) => inj.sl<PostCubit>(),
        ),
      ],
      child: PostDetailPageWidget(postId: postId),
    );
  }
}
