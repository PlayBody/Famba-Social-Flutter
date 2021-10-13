import '../../../../translations/locale_keys.g.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/slider.dart';
import '../../../../extensions.dart';
import '../../../feed/domain/entity/post_entity.dart';
import '../../../feed/presentation/widgets/feed_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ThreadedPostItem extends StatefulWidget {
  final bool startingThread;
  final bool lastThread;
  final PostEntity postEntity;
  const ThreadedPostItem(
      {Key key,
      this.startingThread = false,
      this.lastThread = false,
      this.postEntity})
      : super(key: key);

  @override
  _ThreadedPostItemState createState() => _ThreadedPostItemState();
}

class _ThreadedPostItemState extends State<ThreadedPostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          25.toSizedBox,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.postEntity.profileUrl
                  .toRoundNetworkImage(radius: 13)
                  .toFlexible(),
              'test'.toText.toContainer(color: Colors.red)
            ],
          ),
          [
            5.toSizedBox,
            [
              widget.postEntity.name.toSubTitle1(
                  color: Colors.black, fontWeight: FontWeight.bold),
              20.toSizedBoxHorizontal,
              Container(
                height: 5,
                width: 5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
              5.toSizedBoxHorizontal,
              widget.postEntity.time.toCaption(),
              [
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ).toContainer().toHorizontalPadding(4).toContainer(
                      alignment: Alignment.centerRight,
                    )
              ].toRow(mainAxisAlignment: MainAxisAlignment.end).toExpanded()
            ]
                .toRow(
                  crossAxisAlignment: CrossAxisAlignment.center,
                )
                .toContainer(
                  alignment: Alignment.topCenter,
                ),
            widget.postEntity.userName.toSubTitle1(),
            5.toSizedBox,
            [
              LocaleKeys.in_response_to_his.tr().toCaption(fontSize: 13),
              5.toSizedBoxHorizontal,
              5.toSizedBoxHorizontal,
              LocaleKeys.post.tr().toCaption(fontSize: 13)
            ].toRow().toVisibility(widget.postEntity.responseTo != null),
            if (widget.postEntity.media?.isNotEmpty)
              CustomSlider(
                  mediaItems: widget?.postEntity?.media,
                  isOnlySocialLink: false),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: widget.postEntity.description.toSubTitle1(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.toSizedBox,
            [
              [
                buildPostButton(
                  AppIcons.commentIcon,
                  widget.postEntity.commentCount,
                ).onTapWidget(
                  () {},
                ),
                buildPostButton(
                  AppIcons.repostIcon(),
                  widget.postEntity.repostCount,
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .toExpanded(flex: 4),
              getShareOptionMenu()
                  .toContainer(
                    alignment: const Alignment(0.4, 0),
                  )
                  .toExpanded(flex: 1),
            ].toRow(),
          ]
              .toColumn(mainAxisAlignment: MainAxisAlignment.start)
              .toHorizontalPadding(12)
              .toExpanded(flex: 4)
        ],
      ),
    );
  }
}
