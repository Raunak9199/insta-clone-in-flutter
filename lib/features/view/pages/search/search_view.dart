import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socio_chat/cubit/post/post_cubit.dart';
import 'package:socio_chat/features/view/pages/search/widgets/search_view_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => inj.sl<PostCubit>(),
        ),
        // BlocProvider(
        //   create: (context) => inj.sl<UserCubit>(),
        // ),
      ],
      child: const SearchPageWidget(),
    );
  }
}
