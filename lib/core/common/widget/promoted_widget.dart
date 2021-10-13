import '../../theme/colors.dart';
import '../../../features/feed/domain/entity/post_entity.dart';
import 'package:flutter/material.dart';
import '../../../extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotedWidget extends StatefulWidget {
  final AdvertisementEntity advertisementEntity;

  const PromotedWidget({Key key, this.advertisementEntity}) : super(key: key);
  @override
  _PromotedWidgetState createState() => _PromotedWidgetState();
}

class _PromotedWidgetState extends State<PromotedWidget> {
  @override
  Widget build(BuildContext context) {
    var item = widget.advertisementEntity;
    return Container(
      child: [
        "Sponsored"
            .toHeadLine6(fontWeight: FontWeight.bold)
            .toHorizontalPadding(4),
        [
          item.adTitle.toCaption(fontWeight: FontWeight.bold),
          5.toSizedBox,
          item.adSubTitle.toCaption(fontWeight: FontWeight.bold),
          5.toSizedBox,
          item.adMediaUrl.toNetWorkOrLocalImage(
              borderRadius: 0, width: context.getScreenWidth, height: 150),
          10.toSizedBox,
          [
            [
              item.bodyText.toCaption(),
              item.adWebsite.toCaption(
                  fontWeight: FontWeight.bold, color: AppColors.colorPrimary)
            ].toColumn().toFlexible(),
            "Learn More".toCaption().toOutlinedBorder(() async {
              await launch(item.onClickUrl);
            }, borderRadius: 2).toFlexible()
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        ].toColumn().toPadding(12).toContainer(color: AppColors.lightSky)
      ].toColumn(),
    ).toPadding(8).toHorizontalPadding(8);
  }
}
