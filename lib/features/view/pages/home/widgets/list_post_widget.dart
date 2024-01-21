import 'package:flutter/material.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/features/view/pages/home/widgets/post_item_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class ListPostWidget extends StatelessWidget {
  const ListPostWidget({
    super.key,
    required this.postState,
  });
  final PostLoaded postState;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: postState.posts.length,
      itemBuilder: ((context, index) {
        return BlocProvider(
          create: (context) => inj.sl<PostCubit>(),
          child: PostWidget(postEntity: postState.posts[index]),
        );
      }),
    );
  }
}
