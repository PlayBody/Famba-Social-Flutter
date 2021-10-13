import '../../../../translations/locale_keys.g.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/animations/fade_widget.dart';
import '../../../../core/widgets/animations/slide_bottom_widget.dart';
import '../../../feed/presentation/bloc/feed_cubit.dart';
import '../../../feed/presentation/widgets/all_home_screens.dart';
import '../../../feed/presentation/widgets/no_data_found_screen.dart';
import '../../domain/entity/notification_entity.dart';
import '../bloc/notification_cubit.dart';
import '../widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationCubit _notificationCubit;
  @override
  void initState() {
    super.initState();
    _notificationCubit = BlocProvider.of<NotificationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationCubit>(
      create: (_) => _notificationCubit,
      child: Stack(
        children: [
          StreamBuilder<Set<int>>(
            initialData: Set(),
            stream: _notificationCubit.notificationPagination.deletedItems,
            builder: (context, snapshot) {
              return RefreshIndicator(
                onRefresh: () {
                  _notificationCubit.notificationPagination.onRefresh();
                  return Future.value();
                },
                child: PagedListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  pagingController: _notificationCubit
                      .notificationPagination.pagingController,
                  builderDelegate:
                      PagedChildBuilderDelegate<NotificationEntity>(
                    noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                      title: LocaleKeys.no_notifications_yet.tr(),
                      buttonText: LocaleKeys.go_to_the_homepage.tr(),
                      message: LocaleKeys
                          .there_seems_to_be_you_have_no_notifications_yet_all_notifications
                          .tr(),
                      icon: const Icon(
                        FontAwesomeIcons.bell,
                        size: 40,
                        color: AppColors.colorPrimary,
                      ),
                      onTapButton: () {
                        BlocProvider.of<FeedCubit>(context)
                            .changeCurrentPage(const ScreenType.home());
                        // ExtendedNavigator.root.push(Routes.createPost);
                      },
                    ),
                    itemBuilder: (_, item, index) => CustomAnimatedWidget(
                      child: NotificationItem(
                        notificationEntity: item,
                        onChanged: (v) {
                          if (v)
                            _notificationCubit.notificationPagination
                                .addDeletedItem(
                              index,
                            ); // Add to to be deleted list
                          else
                            _notificationCubit.notificationPagination
                                .deleteSelectedItem(
                              index,
                            ); // delete from to be deleted list
                        },
                        isSelected: snapshot.data.toList().contains(index),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder<Set<int>>(
              initialData: Set(),
              stream: _notificationCubit.notificationPagination.deletedItems,
              builder: (context, snapshot) {
                return SlideBottomWidget(
                  doForward: snapshot.data.isNotEmpty,
                  child: Material(
                    elevation: 10.0,
                    child: ListTile(
                      title: StreamBuilder<Set<int>>(
                        initialData: Set(),
                        stream: _notificationCubit
                            .notificationPagination.deletedItems,
                        builder: (context, snapshot) {
                          return "${LocaleKeys.delete_selected.tr()} (${snapshot.data.length})"
                              .toSubTitle2(fontWeight: FontWeight.w600);
                        },
                      ),
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
                            _notificationCubit.notificationPagination
                                .deleteNotification();
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
