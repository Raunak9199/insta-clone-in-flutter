import 'package:flutter/material.dart';
import 'package:socio_chat/cubit/global-msg/download-cubit/download_cubit_cubit.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class DisplayFullChatImage extends StatelessWidget {
  final GlobalChatEntity messageEntity;
  const DisplayFullChatImage({super.key, required this.messageEntity});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => inj.sl<DownloadCubitCubit>(),
      child: DisplayFullChatImageWidget(
        messageEntity: messageEntity,
      ),
    );
  }
}

class DisplayFullChatImageWidget extends StatefulWidget {
  final GlobalChatEntity messageEntity;
  const DisplayFullChatImageWidget({super.key, required this.messageEntity});

  @override
  State<DisplayFullChatImageWidget> createState() =>
      _DisplayFullChatImageWidgetState();
}

class _DisplayFullChatImageWidgetState extends State<DisplayFullChatImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // user-prof
    return BlocBuilder<DownloadCubitCubit, DownloadCubitState>(
      builder: (context, state) {
        return AppScaffold(
          appBar: AppNewAppBar(
            params: AppAppBarModel(
              isBack: Platform.isAndroid,
              isIosBack: Platform.isIOS,
              elevation: 0.4,
              title: "${widget.messageEntity.senderName}",
              titleStyle: TextStyle(
                color: Colors.black,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: (state is DownloadCubitLoading)
                      ? Padding(
                          padding: EdgeInsets.all(12.w),
                          child: CircularProgressIndicator(
                            value: state.progress,
                            valueColor: _colorAnimation,
                            color: Colors.blue,
                          ),
                        )
                      : (state is DownloadCubitLoaded)
                          ? Icon(
                              Icons.download_done,
                              size: 24.w,
                              color: Colors.green,
                            )
                          : IconButton(
                              onPressed: () async {
                                downloadMethod(context);
                              },
                              icon: Icon(
                                Icons.download,
                                size: 24.w,
                                color: Colors.black,
                              ),
                            ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: ImageDisplayWidget(
                    imgUrl: widget.messageEntity.chatImgFile!, fit: BoxFit.fill,
                    // imgUrl: imageFile!.path,
                  ),
                ),
                // ),
              ),
            ),
          ),
        );
      },
    );
  }

  downloadMethod(BuildContext context) async {
    final provider = BlocProvider.of<DownloadCubitCubit>(context);
    await provider.downloadChatImage(
        message: widget.messageEntity,
        imageName: widget.messageEntity.senderName!);
  }
}
