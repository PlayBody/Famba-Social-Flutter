import 'dart:async';

import 'package:auto_route/auto_route.dart';
import '../../domain/entity/message_entity.dart';
import '../../../../translations/locale_keys.g.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import '../../../../core/common/push_notification/push_notification_helper.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/images.dart';
import '../../../../core/widgets/loading_bar.dart';
import '../../../../core/widgets/media_picker.dart';
import '../../../../extensions.dart';
import '../../../feed/presentation/widgets/create_post_card.dart';
import '../../../feed/presentation/widgets/no_data_found_screen.dart';
import '../../data/models/request/delete_chat_request_model.dart';
import '../../domain/entity/chat_entity.dart';
import '../bloc/chat_cubit.dart';
import '../widgets/reviever_chat_item.dart';
import '../widgets/sender_chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatScreen extends StatefulWidget {
  final String otherPersonUserId;
  final String otherUserFullName;
  final String otherPersonProfileUrl;
  final MessageEntity entity;
  const ChatScreen({
    Key key,
    this.otherPersonUserId,
    this.otherUserFullName,
    this.otherPersonProfileUrl,
    this.entity,
  }) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  ChatCubit chatCubit;
  ScrollController controller = ScrollController();
  bool chatCleared = false;
  bool chatDeleted = false;
  @override
  void initState() {
    super.initState();
    chatCubit = getIt<ChatCubit>()
      ..chatPagination.userId = widget.otherPersonUserId;
    chatCubit.chatPagination.searchChat = false;
    PushNotificationHelper.listenNotificationOnChatScreen = (notificationItem) {
      chatCubit.changeMessageList(
          chatCubit.chatPagination.pagingController.itemList
            ..insert(0, notificationItem));
      chatCubit.chatPagination.pagingController;
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.initScreenUtil();
    return WillPopScope(
      onWillPop: () async {
        navigateToBackWithResult();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => navigateToBackWithResult(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.otherUserFullName.toSubTitle1(
                color: const Color(0xFF3D4146),
                fontWeight: FontWeight.w700,
                fontFamily1: 'CeraPro',
              ),
              AppIcons.verifiedIcons
                  .toVisibility(
                      widget.entity == null ? false : widget.entity.isVerified)
                  .toHorizontalPadding(4),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: context.isArabic() ? 0 : 8.0,
                left: !context.isArabic() ? 0 : 8.0,
              ),
              child: GestureDetector(
                onTap: () => bottomSheet(context),
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned(
              top: 80,
              width: context.getScreenWidth,
              // left: 0,
              bottom: 70,
              // height: context.getScreenHeight,
              child: BlocListener<ChatCubit, CommonUIState>(
                bloc: chatCubit,
                listener: (BuildContext context, state) {
                  state.maybeWhen(
                      orElse: () {},
                      success: (s) {
                        if (s is String) {
                          if (s
                              .toLowerCase()
                              .contains(LocaleKeys.clear_chat.tr()))
                            chatCleared = true;
                          else if (s
                              .toLowerCase()
                              .contains(LocaleKeys.delete_chat.tr())) {
                            chatDeleted = true;
                            navigateToBackWithResult();
                          }
                          context.showSnackBar(message: s);
                        }
                      },
                      error: (e) =>
                          context.showSnackBar(isError: true, message: e));
                },
                child: BlocBuilder<ChatCubit, CommonUIState>(
                    bloc: chatCubit,
                    builder: (c, state) {
                      print(state);
                      return state.maybeWhen(
                          orElse: () => LoadingBar(),
                          success: (s) => buildRefreshIndicator(),
                          error: (e) => buildRefreshIndicator());
                    }),
              ),
            ),
            Positioned(
                bottom: 0,
                width: context.getScreenWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      onChanged: chatCubit.message.onChange,
                      controller: chatCubit.message.textController,
                      // style: AppTheme.button.copyWith(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Type Something...',
                        contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintStyle: context.subTitle2,
                        labelStyle: AppTheme.caption
                            .copyWith(fontWeight: FontWeight.bold),
                        suffixIcon: SvgPicture.asset(
                          Images.chatImage,
                          height: 10,
                          width: 10,
                        ).toPadding(14).onTapWidget(() async {
                          await openMediaPicker(context, (image) async {
                            chatCubit.sendImage(
                                image, widget.otherPersonUserId);
                          }, mediaType: MediaTypeEnum.IMAGE);
                        }),
                      ),
                    )
                        .toContainer(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: const Color(0xFFECF1F6),
                                borderRadius: BorderRadius.circular(40)))
                        .toFlexible(),
                    SvgPicture.asset(
                      Images.sendIcon,
                      height: 24,
                    ).toHorizontalPadding(12).onTapWidget(() async {
                      if (chatCubit.message.text.trim().isNotEmpty) {
                        chatCubit.sendMessage(widget.otherPersonUserId);
                        chatCubit.message.textController.clear();
                      } else {
                        context.showSnackBar(
                            message: "Please enter a valid text",
                            isError: true);
                      }
                    }, removeFocus: false),
                  ],
                ).toPadding(8)),
            buildFloatingSearchBar(),
          ],
        ),
      ),
    );
  }

  RefreshIndicator buildRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: () {
        chatCubit.chatPagination.searchChat = false;
        chatCubit.chatPagination.onRefresh();
        return Future.value();
      },
      child: PagedListView(
        reverse: true,
        pagingController: chatCubit.chatPagination.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ChatEntity>(
          noItemsFoundIndicatorBuilder: (i) => NoDataFoundScreen(
            onTapButton: () {
              // ExtendedNavigator.root.push(Routes.createPost);
            },
            title: LocaleKeys.no_messages.tr(),
            buttonText: LocaleKeys.go_to_the_homepage.tr(),
            message: "",
            buttonVisibility: false,
          ),
          itemBuilder: (BuildContext context, item, int index) => Container(
            width: context.getScreenWidth,
            child: item.isSender
                ? SenderChatItem(chatEntity: item, chatCubit: chatCubit)
                : ReceiverChatItem(
                    otherUserProfileUrl: widget.otherPersonProfileUrl,
                    chatEntity: item,
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final floatingSearchBarController = FloatingSearchBarController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: FloatingSearchBar(
        controller: floatingSearchBarController,
        hint: LocaleKeys.search_for_messages.tr(),
        hintStyle: context.subTitle2.copyWith(
          fontWeight: FontWeight.bold,
          color: Color(0xFF5B626B),
          fontFamily: 'CeraPro',
        ),
        backgroundColor: Colors.grey.shade200,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 400),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        automaticallyImplyBackButton: false,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        elevation: 0.0,
        debounceDelay: const Duration(milliseconds: 500),
        actions: [],
        leadingActions: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 12, bottom: 12, right: 16),
            child: SvgPicture.asset(
              Images.search,
              height: 20,
              width: 20,
            ),
          ),
        ],
        onQueryChanged: (query) {
          chatCubit.chatPagination.searchChat = true;
          chatCubit.chatPagination.queryText = query;
        },
        transition: CircularFloatingSearchBarTransition(),
        builder: (context, transition) {
          return const SizedBox();
        },
      ),
    );
  }

  void navigateToBackWithResult() {
    if (chatDeleted) {
      ExtendedNavigator.root.pop("deleted");
    } else if (chatCleared) {
      ExtendedNavigator.root.pop("cleared");
    } else
      ExtendedNavigator.root.pop(chatCubit.getLastMessage());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    PushNotificationHelper.listenNotificationOnChatScreen = null;
    super.dispose();
  }

  bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              height: context.getScreenHeight * .2,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                top: 15,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff0e8df1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 6,
                    width: 37,
                    decoration: const BoxDecoration(
                      color: const Color(0xff0560b2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // TODO Uncomment this when the developer responds
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: Container(
                        //     height: 25,
                        //     margin: const EdgeInsets.only(top: 30),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.flag_outlined,
                        //           color: Colors.white,
                        //         ),
                        //         const SizedBox(width: 20),
                        //         Text(
                        //           'Report Chat',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.w400,
                        //             fontFamily: "CeraPro",
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () async {
                            (await showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              animationType: DialogTransitionType.size,
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(seconds: 1),
                              builder: (_) => AlertDialog(
                                title: LocaleKeys.please_confirm_your_actions
                                    .tr()
                                    .toSubTitle1(fontWeight: FontWeight.bold),
                                content: LocaleKeys
                                    .do_you_want_to_delete_this_chat_with_please_note_that_this_action
                                    .tr(namedArgs: {
                                  '@interloc_name@': widget.otherUserFullName
                                }).toSubTitle1(),
                                actions: <Widget>[
                                  LocaleKeys.cancel
                                      .tr()
                                      .toButton()
                                      .toFlatButton(
                                    () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  LocaleKeys.yes.tr().toButton().toFlatButton(
                                        () async => await deleteMethod(true),
                                      )
                                ],
                              ),
                            ));
                          },
                          child: Container(
                            height: 25,
                            margin: const EdgeInsets.only(top: 30),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  LocaleKeys.delete_chat.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "CeraPro",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            (await showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              animationType: DialogTransitionType.size,
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(seconds: 1),
                              builder: (_) => AlertDialog(
                                title: LocaleKeys.please_confirm_your_actions
                                    .tr()
                                    .toSubTitle1(fontWeight: FontWeight.bold),
                                content: LocaleKeys
                                    .are_you_sure_you_want_to_delete_all_messages_in_the_chat_with_ple
                                    .tr(
                                  namedArgs: {
                                    '@interloc_name@': widget.otherUserFullName
                                  },
                                ).toSubTitle2(),
                                actions: <Widget>[
                                  LocaleKeys.cancel
                                      .tr()
                                      .toButton()
                                      .toFlatButton(
                                    () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  LocaleKeys.yes.tr().toButton().toFlatButton(
                                        () async => await deleteMethod(false),
                                      )
                                ],
                              ),
                            ));
                          },
                          child: Container(
                            height: 25,
                            margin: const EdgeInsets.only(top: 30),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.message_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  LocaleKeys.clear_chat.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "CeraPro",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  Future<void> deleteMethod(bool deleteAndClear) async {
    Navigator.pop(context);
    Navigator.pop(context);
    await chatCubit.deleteAllMessages(
      DeleteChatRequestModel(
        deleteChat: deleteAndClear,
        userId: widget.otherPersonUserId,
      ),
    );
    chatDeleted = deleteAndClear;
    navigateToBackWithResult();
  }
}
