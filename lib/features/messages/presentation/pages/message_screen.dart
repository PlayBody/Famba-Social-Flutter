import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/constants/appconstants.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/images.dart';
import '../../../../core/widgets/animations/fade_widget.dart';
import '../../../../core/widgets/loading_bar.dart';
import '../../../../extensions.dart';
import '../../../feed/presentation/bloc/feed_cubit.dart';
import '../../../feed/presentation/widgets/all_home_screens.dart';
import '../../../feed/presentation/widgets/no_data_found_screen.dart';
import '../../domain/entity/message_entity.dart';
import '../bloc/message_cubit.dart';
import 'chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessageCubit messageCubit;

  @override
  void initState() {
    super.initState();
    messageCubit = getIt<MessageCubit>()..getMessages();
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return Scaffold(
      body: BlocBuilder<MessageCubit, MessageState>(
        bloc: messageCubit,
        builder: (_, state) {
          return state.when(
            initial: () => LoadingBar(),
            success: (s) => RefreshIndicator(
              onRefresh: () {
                messageCubit.getMessages();
                return Future.value();
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    brightness: Brightness.light,
                    automaticallyImplyLeading: false,
                    leading: null,

                    elevation: 10.0,
                    expandedHeight: 100.toHeight,
                    floating: true,
                    pinned: true,
                    centerTitle: true,
                    title: LocaleKeys.messages.tr().toSubTitle1(
                          color: const Color(0xFF3D4146),
                          fontWeight: FontWeight.w700,
                          fontFamily1: 'CeraPro',
                        ),
                    backgroundColor: Colors.white,
                    // TODO Uncomment this when the developer responds
                    // actions: [
                    //   Padding(
                    //     padding: EdgeInsets.only(
                    //       right: context.isArabic() ? 0 : 8.0,
                    //       left: !context.isArabic() ? 0 : 8.0,
                    //     ),
                    //     child: GestureDetector(
                    //       onTap: () => bottomSheet(context),
                    //       child: Icon(
                    //         Icons.more_horiz,
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ),
                    // ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: [
                        LocaleKeys.search_for_messages
                            .tr()
                            .toSearchBarField(onTextChange: (text) {
                              messageCubit.doSearching(text);
                            })
                            .toHorizontalPadding(30)
                            .toContainer(height: 65)
                      ].toColumn(mainAxisAlignment: MainAxisAlignment.end),
                    ),
                    // title:
                  ),
                  buildHome()
                ],
              ).toContainer(color: Colors.white),
            ),
            loading: () => LoadingBar(),
            noData: () => NoDataFoundScreen(
              onTapButton: () {
                BlocProvider.of<FeedCubit>(context).changeCurrentPage(
                  const ScreenType.home(),
                );
              },
              icon: AppIcons.messageProfile(size: 40),
              buttonText: LocaleKeys.go_to_the_homepage.tr(),
              title: LocaleKeys.no_chats_yet.tr(),
              message: LocaleKeys
                  .oops_it_looks_like_you_don_t_have_any_chat_history_yet_to_start_c
                  .tr(namedArgs: {'@svg_icon@': 'message Icon'}),
            ),
            error: (e) => e.toText.toCenter(),
          );
        },
      ),
    );
  }

  Widget buildHome() {
    return StreamBuilder<List<MessageEntity>>(
        stream: messageCubit.messageItems,
        initialData: [],
        builder: (context, snapshot) {
          return snapshot.data.isEmpty
              ? SliverToBoxAdapter(
                  child: StreamBuilder<String>(
                    stream: messageCubit.searchItem,
                    initialData: '',
                    builder: (context, snapshot) {
                      return NoDataFoundScreen(
                        onTapButton: () {
                          BlocProvider.of<FeedCubit>(context)
                              .changeCurrentPage(const ScreenType.home());
                        },
                        icon: Images.search.toSvg(
                            color: AppColors.colorPrimary,
                            height: 40,
                            width: 40),
                        buttonVisibility: false,
                        title: LocaleKeys.nothing_found.tr(),
                        message: LocaleKeys
                            .could_not_find_anything_in_your_chats_history_for_your_search_que
                            .tr(
                          namedArgs: {
                            '@search_query@': snapshot.data,
                          },
                        ),
                      );
                    },
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => snapshot.data.isEmpty
                        ? const SizedBox()
                        : CustomAnimatedWidget(
                            child: OpenContainer<dynamic>(
                              closedElevation: 0.0,
                              closedBuilder: (i, c) => Dismissible(
                                confirmDismiss: (direction) async {
                                  return await context.showOkCancelAlertDialog<
                                          bool>(
                                      title: LocaleKeys
                                          .please_confirm_your_actions
                                          .tr(),
                                      desc: LocaleKeys
                                          .do_you_want_to_delete_this_chat_with_please_note_that_this_action
                                          .tr(namedArgs: {
                                        '@interloc_name@':
                                            snapshot.data[index].fullName
                                      }),
                                      okButtonTitle: LocaleKeys.delete.tr(),
                                      onTapOk: () async {
                                        final result = await messageCubit
                                            .deletAllMessages(index);
                                        ExtendedNavigator.root.pop(result);
                                      });
                                },
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: AppColors.colorPrimary,
                                  child: [
                                    TextButton.icon(
                                      icon: SvgPicture.asset(
                                        Images.delete,
                                        color: Colors.white,
                                        height: 16,
                                        width: 16,
                                      ),
                                      label: LocaleKeys.delete.tr().toCaption(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      onPressed: () {},
                                    ),
                                  ]
                                      .toRow(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center)
                                      .toHorizontalPadding(12),
                                ),
                                key: UniqueKey(),
                                child: snapshot.data.isEmpty
                                    ? const SizedBox()
                                    : messageItem(entity: snapshot.data[index]),
                              ),
                              openBuilder: (i, c) => ChatScreen(
                                otherPersonProfileUrl:
                                    snapshot.data[index].profileUrl,
                                otherUserFullName:
                                    snapshot.data[index].fullName,
                                otherPersonUserId: snapshot.data[index].userId,
                                entity: snapshot.data[index],
                              ),
                              onClosed: (s) async {
                                // context.showSnackBar(message: s);
                                // if we got cleared value then we will remove the last message only
                                if (s == null) return;
                                if (s is String) {
                                  if (s == "cleared")
                                    messageCubit.clearChat(index);
                                  else if (s == 'deleted')
                                    messageCubit.deleteChat(index);
                                } else {
                                  messageCubit.updateCurrentMessage(index, s);
                                  // context.showSnackBar(message: s.message);
                                }
                              },
                            ),
                          ),
                    childCount: snapshot.data.length,
                  ),
                );
        });
  }

  Widget messageItem({MessageEntity entity}) {
    return [
      10.toSizedBox,
      entity.profileUrl.toRoundNetworkImage(radius: 10),
      5.toSizedBox,
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RichText(
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  strutStyle: StrutStyle.disabled,
                  textWidthBasis: TextWidthBasis.longestLine,
                  text: TextSpan(
                    text: entity.fullName,
                    style: context.subTitle1.copyWith(
                      color: const Color(0xFF3D4146),
                      fontWeight: FontWeight.w600,
                      fontSize: AC.device17(context),
                      fontFamily: "CeraPro",
                    ),
                  ),
                ),
                AppIcons.verifiedIcons
                    .toVisibility(entity.isVerified ?? false)
                    .toHorizontalPadding(4),
              ],
            ),
            Flexible(
              child: Text(
                entity.time,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF737880),
                  fontSize: AC.getDeviceHeight(context) * 0.013,
                  fontWeight: FontWeight.w600,
                  fontFamily: "CeraPro",
                ),
              ),
            ),
          ],
        ),
        Text(
          "@${entity.userName}",
          style: TextStyle(
            color: const Color(0xFF737880),
            fontSize: AC.getDeviceHeight(context) * 0.015,
            fontWeight: FontWeight.w600,
            fontFamily: "CeraPro",
          ),
        ),
        5.toSizedBox,
        Text(
          entity.message,
          maxLines: 2,
          style: TextStyle(
            color: const Color(0xFF6A7079),
            fontSize: AC.getDeviceHeight(context) * 0.015,
            fontWeight: FontWeight.w600,
            fontFamily: "CeraPro",
          ),
        ),
      ].toColumn().toExpanded()
    ].toRow().toPadding(13).toContainer().makeBottomBorder;
  }

  bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              height: context.getScreenHeight * .15,
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
                        InkWell(
                          onTap: () {},
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
                                  'Delete All Messages',
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
}
