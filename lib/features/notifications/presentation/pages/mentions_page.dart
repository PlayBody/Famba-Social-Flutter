import '../../../../translations/locale_keys.g.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/animations/slide_bottom_widget.dart';
import '../../../feed/presentation/bloc/feed_cubit.dart';
import '../../../feed/presentation/widgets/all_home_screens.dart';
import '../../../feed/presentation/widgets/no_data_found_screen.dart';
import '../../domain/entity/notification_entity.dart';
import '../bloc/notification_cubit.dart';
import '../widgets/notification_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class MentionsPage extends StatefulWidget {
  @override
  _MentionsPageState createState() => _MentionsPageState();
}

class _MentionsPageState extends State<MentionsPage>
    with SingleTickerProviderStateMixin {
  NotificationCubit _notificationCubit;
  @override
  void initState() {
    super.initState();
    _notificationCubit = BlocProvider.of<NotificationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<Set<int>>(
            stream: _notificationCubit.mentionsPagination.deletedItems,
            initialData: Set(),
            builder: (context, snapshot) {
              return RefreshIndicator(
                onRefresh: () {
                  _notificationCubit.mentionsPagination.onRefresh();
                  return Future.value();
                },
                child: StreamBuilder<Set<int>>(
                    stream: _notificationCubit.mentionsPagination.deletedItems,
                    builder: (context, snapshot) {
                      return PagedListView(
                          padding: const EdgeInsets.only(bottom: 80),
                          pagingController: _notificationCubit
                              .mentionsPagination.pagingController,
                          builderDelegate: PagedChildBuilderDelegate<
                                  NotificationEntity>(
                              noItemsFoundIndicatorBuilder: (_) =>
                                  NoDataFoundScreen(
                                    title: LocaleKeys.no_mentions_yet.tr(),
                                    buttonText:
                                        LocaleKeys.go_to_the_homepage.tr(),
                                    message: LocaleKeys
                                        .there_seems_to_be_no_mention_of_you_all_links_to_you_in_user_publ
                                        .tr(),
                                    icon: const Icon(
                                      FontAwesomeIcons.at,
                                      size: 40,
                                      color: AppColors.colorPrimary,
                                    ),
                                    onTapButton: () {
                                      BlocProvider.of<FeedCubit>(context)
                                          .changeCurrentPage(
                                              const ScreenType.home());
                                      // ExtendedNavigator.root.push(Routes.createPost);
                                    },
                                  ),
                              itemBuilder: (_, item, index) => NotificationItem(
                                    notificationEntity: item,
                                    onChanged: (v) {
                                      if (v)
                                        _notificationCubit.mentionsPagination
                                            .addDeletedItem(index);
                                      else
                                        _notificationCubit.mentionsPagination
                                            .deleteSelectedItem(index);
                                    },
                                    isSelected: snapshot?.data
                                            ?.toList()
                                            ?.contains(index) ??
                                        false,
                                  )));
                    }),
              );
            }),
        Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder<Set<int>>(
            initialData: Set<int>(),
            stream: _notificationCubit.mentionsPagination.deletedItems,
            builder: (context, snapshot) {
              return SlideBottomWidget(
                doForward: snapshot.data.isNotEmpty,
                child: ListTile(
                  title: StreamBuilder<Set<int>>(
                      initialData: Set(),
                      stream:
                          _notificationCubit.mentionsPagination.deletedItems,
                      builder: (context, snapshot) {
                        return "${LocaleKeys.delete_selected.tr()} (${snapshot.data.length})"
                            .toSubTitle2(fontWeight: FontWeight.w600);
                      }),
                  trailing: AppIcons.deleteOption(),
                  tileColor: Colors.white,
                  onTap: () {
                    context.showOkCancelAlertDialog(
                      desc:
                          "Are you sure you want to delete the selected notifications? Please note that this action cannot be undone!",
                      title: LocaleKeys.please_confirm_your_actions.tr(),
                      okButtonTitle: LocaleKeys.delete.tr(),
                      onTapOk: () {
                        Navigator.of(context).pop();
                        _notificationCubit.mentionsPagination
                            .deleteNotification();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
