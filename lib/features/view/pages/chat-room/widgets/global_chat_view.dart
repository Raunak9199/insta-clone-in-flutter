import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;
import 'package:socio_chat/features/view/pages/auth/domain/usecases/store_post_usecase.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:uuid/uuid.dart';
import 'widgets.dart';

import 'msg_container.dart';

class GlobalChatView extends StatefulWidget {
  final UserEntity user;
  const GlobalChatView({super.key, required this.user});

  @override
  State<GlobalChatView> createState() => _GlobalChatViewState();
}

class _GlobalChatViewState extends State<GlobalChatView> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _messageScrollController = ScrollController();
  bool _isScrolledUp = false;
  bool _isReplying = false;
  bool isLoading = false;
  bool isReplied = false;
  int replyIndex = 0;
  int currentUserIndex = 0;

  // TO display profile of other user
  // String otherUserProfUrl = "";
  GlobalChatEntity message = GlobalChatEntity();
  var position = 0;
  String currentUserUid = "";

  void reachToBottom() => Timer(
      const Duration(milliseconds: 200),
      () => _messageScrollController
          .jumpTo(_messageScrollController.position.maxScrollExtent));
  @override
  void initState() {
    inj.sl<GetCurrentUserUidUseCase>().call().then((uid) => setState(() {
          currentUserUid = uid;
        }));
    BlocProvider.of<GlobalMessageCubit>(context)
        .getGlobalMessage()
        .then((value) {
      reachToBottom();
      /* Timer(
          const Duration(milliseconds: 200),
          () => _messageScrollController
              .jumpTo(_messageScrollController.position.maxScrollExtent)); */
    });
    /* BlocProvider.of<OtherSingleUserDartCubit>(context)
        .fetchEveryOtherUser(otherUid: widget.user.otherId!); */

    super.initState();
  }

  @override
  dispose() {
    _msgController.dispose();
    super.dispose();
  }

  _sendMessage() {
    if (_msgController.text.isNotEmpty) {
      FocusScope.of(context).requestFocus(FocusNode());

      BlocProvider.of<GlobalMessageCubit>(context)
          .sendGlobalMessage(
        GlobalChatEntity(
          message: _msgController.text,
          msgTime: Timestamp.now(),
          senderName: widget.user.name,
          senderId: widget.user.uid,
          recieverId: "",
          recieverName: "",
          senderProfileUrl: widget.user.profileUrl,
          type: "TEXT",
          msgDelId: const Uuid().v1(),
        ),
      )
          .then(
        (value) {
          _msgController.clear();
          reachToBottom();
          setState(() {
            isReplied = true;
            _isReplying = false;
            isReplied = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalMessageCubit, GlobalMessageState>(
      bloc: BlocProvider.of<GlobalMessageCubit>(context),
      builder: (context, state) {
        if (state is GlobalMessageLoaded) {
          return bodyWidget(state);
        } else if (state is GlobalMessageFailure) {
          return const AppScaffold(
            body: Center(child: Text('Failed to load messages')),
          );
        } else {
          return const AppScaffold(
            body: Center(child: AppLoader()),
          );
        }
      },
    );
  }

  Widget bodyWidget(GlobalMessageLoaded msg) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      // floatingActionButton: _buildScrollToBottomButton(),
      body: Column(
        children: [
          ChatHeaderWidget(
            widget: widget,
          ),
          const SizedBox(height: 2),
          // Message Body
          Expanded(
            child: Stack(
              children: [
                _messageBodyList(msg),
                Positioned(
                  right: 15.w,
                  bottom: 10.h,
                  child: ScrollToBottomButton(
                    isScrolledUp: _isScrolledUp,
                    messageScrollController: _messageScrollController,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          // TextField
          bottomTextFieldWidget(msg),
        ],
      ),
    );
  }

  Widget _messageBodyList(GlobalMessageLoaded msg) {
    _messageScrollController.addListener(() {
      setState(() {
        _isScrolledUp = _messageScrollController.position.pixels + 200 <
            _messageScrollController.position.maxScrollExtent;
      });
    });
    var lastIndex = 0;
    return ListView.builder(
      controller: _messageScrollController,
      shrinkWrap: true,
      itemCount: msg.message.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, index) {
        lastIndex = msg.message.length - 1;
        // repIndex = index;
        /*    isLastSeenMessage =
            index == widget.lastSeenMessageIndex; */
        message = msg.message[index];
        return msg.message[index].senderId == widget.user.uid
            ? msg.message[index].type == "IMAGE"
                ? InkWell(
                    onLongPress: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r)),
                              ),
                              child: InkWell(
                                onTap: () => delMessage(msg, index),
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_rounded, size: 24.w),
                                    SizedBox(width: 15.w),
                                    Text(
                                      "Delete Message",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20.sp),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: GestureDetector(
                      onTap: () {
                        GlobalChatEntity newMsg = GlobalChatEntity();
                        newMsg = msg.message[index];
                        Navigator.pushNamed(
                          context,
                          Routes.globalChatFullImageView,
                          arguments: newMsg,
                        );
                      },

                      child: Material(
                        type: MaterialType.transparency,
                        child: ChatImageRenderWidget(
                          context: context,
                          lastIndex: lastIndex,
                          widget: widget,
                          msg: msg,
                          msgIndex: index,
                          senderImageUrl: msg.message[index].senderProfileUrl!,
                        ),
                      ),
                      // ),
                    ),
                  )
                : GestureDetector(
                    onLongPress: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r)),
                              ),
                              child: InkWell(
                                onTap: () => delMessage(msg, index),
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_rounded, size: 24.w),
                                    SizedBox(width: 15.w),
                                    Text(
                                      "Delete Message",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20.sp),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        message.isSwiping = true;
                        _isReplying = true;
                        replyIndex = index;
                        currentUserIndex = index;
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        // Update the swipe position while dragging
                        message.swipePosition =
                            message.swipePosition! + details.primaryDelta!;
                        _isReplying = true;
                        replyIndex = index;
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        // Reset swipe status and position when dragging ends
                        message.isSwiping = false;
                        message.swipePosition = 0;
                        replyIndex = index;
                        // _isReplying = false;
                      });
                    },
                    child: Transform.translate(
                      offset: Offset(message.swipePosition!, 0),
                      child: MsgContainer(
                        msgType: msg.message[index].type,
                        name: widget.user.name,
                        senderId: msg.message[index].senderId!,
                        senderName: msg.message[index].senderName!,
                        message: msg.message[index].message,
                        time: DateFormat('hh:mm a')
                            .format(msg.message[index].msgTime!.toDate()),
                        image: msg.message[index].senderProfileUrl!,
                        color: Colors.green[300],
                        align: TextAlign.left,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxAlignment: MainAxisAlignment.end,
                        uid: widget.user.uid!,
                      ),
                    ),
                  )
            : msg.message[index].type == "IMAGE"
                ? ChatImageRenderWidget(
                    context: context,
                    lastIndex: lastIndex,
                    widget: widget,
                    msg: msg,
                    msgIndex: index,
                    senderImageUrl: msg.message[index].senderProfileUrl!,
                  )
                : GestureDetector(
                    onHorizontalDragStart: (details) {
                      setState(() {
                        message.isSwiping = true;
                        _isReplying = true;
                        replyIndex = index;
                        currentUserIndex = index;
                        isReplied = false;
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        // Update the swipe position while dragging
                        message.swipePosition =
                            message.swipePosition! + details.primaryDelta!;
                        _isReplying = true;
                        replyIndex = index;
                        isReplied = false;
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        // Reset swipe status and position when dragging ends
                        message.isSwiping = false;
                        message.swipePosition = 0;
                        replyIndex = index;
                        isReplied = false;
                        // _isReplying = false;
                      });
                    },
                    child: Transform.translate(
                      offset: Offset(message.swipePosition!, 0),
                      child: Column(
                        children: [
                          isReplied
                              ? Container(
                                  // alignment: Alignment.bottomLeft,
                                  width: double.maxFinite,
                                  constraints: BoxConstraints(maxHeight: 90.h),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      topRight: Radius.circular(15.r),
                                    ),
                                    border: Border.all(
                                        color: Colors.black54, width: 1),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.w, horizontal: 8.w),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            msg.message[replyIndex].senderName!,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            msg.message[replyIndex].message!,
                                            // overflow: TextOverflow.clip,
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          MsgContainer(
                            msgType: msg.message[index].type!,
                            senderName: msg.message[index].senderName!,
                            message: msg.message[index].message,
                            time: DateFormat('hh:mm a')
                                .format(msg.message[index].msgTime!.toDate()),
                            color: AppColor.secondaryDark.withOpacity(0.4),
                            align: TextAlign.left,
                            image: msg.message[index].senderProfileUrl,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxAlignment: MainAxisAlignment.start,
                            uid: '',
                            senderId: msg.message[index].senderId!,
                          ),
                        ],
                      ),
                    ),
                  );
      },
    );
  }

  bottomTextFieldWidget(GlobalMessageLoaded msg) => Container(
        // height: 60.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.secondaryDark.withOpacity(0.67),
              Colors.red.withOpacity(0.4),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                if (_isReplying)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            // alignment: Alignment.bottomLeft,
                            width: double.maxFinite,
                            constraints: BoxConstraints(maxHeight: 90.h),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.r),
                                topRight: Radius.circular(15.r),
                              ),
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.w, horizontal: 8.w),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      msg.message[replyIndex].senderName!,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      msg.message[replyIndex].message!,
                                      // overflow: TextOverflow.clip,
                                      softWrap: true,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _isReplying = false;
                          }),
                          child: Icon(
                            Icons.close,
                            size: 24.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: _isReplying
                              ? "Write a reply..."
                              : "Type a message...",
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        autofocus: _isReplying,
                        maxLines: null,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                      ),
                    ),
                    SizedBox(width: 7.w),
                    InkWell(
                      onTap: () => _openMediaDialog(
                        msg,
                        message,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.w)
                            .copyWith(right: 6.w),
                        child: Icon(
                          Icons.photo_rounded,
                          size: 26.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 7.w),
                    InkWell(
                      onTap: _sendMessage,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.w)
                            .copyWith(right: 6.w),
                        child: Icon(
                          Icons.send,
                          size: 26.h,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  submitChatImage(File? imageFile, GlobalChatEntity messageEntity) {
    setState(() {
      isLoading = true;
    });
    inj
        .sl<StorePostToFirebaseUseCase>()
        .call(
          imageFile,
          "chatImageFile",
          messageEntity.msgDelId!,
        )
        .then(
      (postImgUrl) {
        createChatImage(
          imageUrl: postImgUrl,
        );
      },
    ).then((value) {
      reachToBottom();
      setState(() {
        isLoading = false;
      });
    });
  }

  createChatImage({required String imageUrl}) {
    // Navigator.pop(context);
    FocusScope.of(context).requestFocus(FocusNode());
    BlocProvider.of<GlobalMessageCubit>(context)
        .uploadChatImage(
      GlobalChatEntity(
        chatImgFile: imageUrl,
        msgTime: Timestamp.now(),
        // message: "",
        senderProfileUrl: widget.user.profileUrl,
        senderName: widget.user.name,
        senderId: widget.user.uid,
        recieverId: "",
        recieverName: "",
        type: "IMAGE",
        msgDelId: const Uuid().v1(),
      ),
    )
        .then(
      (value) {
        setState(() {
          isLoading = false;
          log("Uploaded");
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        });
      },
    );
  }

  delMessage(GlobalMessageLoaded msg, int index) {
    BlocProvider.of<GlobalMessageCubit>(context).deleteChatMsg(
      delMsg: GlobalChatEntity(
        msgDelId: msg.message[index].msgDelId,
        // userUid: widget.userUid,
      ),
    );
    reachToBottom();
    log(msg.message[index].msgDelId.toString());
    Navigator.pop(context);
    Get.showSnackbar(const GetSnackBar(
      message: "Message Deleted",
      snackPosition: SnackPosition.TOP,
    ));
  }

  void _openMediaDialog(GlobalMessageLoaded msg, GlobalChatEntity msgEntity) {
    isLoading
        ? const AlertDialog(
            content: Center(
              child: AppLoader(),
            ),
          )
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Choose"),
                content: isLoading
                    ? const Center(
                        child: AppLoader(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.camera);
                              if (image != null) {
                                Navigator.pop;
                                submitChatImage(File(image.path), msgEntity);
                              }
                            },
                            child: Icon(Icons.camera_alt_rounded, size: 28.w),
                          ),
                          InkWell(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                Navigator.pop;
                                submitChatImage(File(image.path), msgEntity);
                              }
                            },
                            child: Icon(Icons.photo_rounded, size: 28.w),
                          ),
                        ],
                      ),
              );
            });
  }
}
