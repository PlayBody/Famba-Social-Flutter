import '../../../../core/theme/colors.dart';
import '../widgets/create_post_card.dart';
import 'package:flutter/material.dart';

class RedeemConfirmationScreen extends StatefulWidget {
  final Function backRefresh;
  const RedeemConfirmationScreen({Key key, this.backRefresh}) : super(key: key);

  @override
  _RedeemConfirmationScreenState createState() =>
      _RedeemConfirmationScreenState();
}

class _RedeemConfirmationScreenState extends State<RedeemConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedContainer(
          width: MediaQuery.of(context).size.width,
          height: 320,
          decoration: BoxDecoration(
            color: AppColors.alertBg.withOpacity(0.5),
          ),
          duration: const Duration(microseconds: 500),
          curve: Curves.easeInCirc,
          child: Container(
            color: Colors.white,
            child: CreatePostCard(
              backData: (index) {
                Future.delayed(
                  Duration(microseconds: 300),
                  () {
                    widget.backRefresh();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
