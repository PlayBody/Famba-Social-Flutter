import '../../../../core/common/widget/common_divider.dart';
import '../../../../core/theme/colors.dart';
import 'create_poll_textField.dart';
import '../../../../translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../extensions.dart';

class CreatePollContainer extends StatefulWidget {
  const CreatePollContainer(
    this.fun, {
    Key key,
    @required this.controller1,
    @required this.controller2,
    @required this.controller3,
    @required this.controller4,
  }) : super(key: key);
  final VoidCallback fun;
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final TextEditingController controller4;

  @override
  _CreatePollContainerState createState() => _CreatePollContainerState();
}

class _CreatePollContainerState extends State<CreatePollContainer> {
  int _numberOfChoices = 2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 50),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.create_a_new_poll.tr().toUpperCase(),
                  style: TextStyle(
                    color: AppColors.colorPrimary,
                    fontFamily: 'CeraPro',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                GestureDetector(
                  onTap: widget.fun,
                  child: Icon(
                    Icons.close,
                    color: AppColors.colorPrimary,
                  ),
                )
              ],
            ),
            commonDivider,
            Column(
              children: [
                CreatePollTextField(
                  controller: widget.controller1,
                  onSubmitted: (String text) {},
                  hintText: 'Option - 1',
                ),
                CreatePollTextField(
                  controller: widget.controller2,
                  onSubmitted: (String text) {},
                  hintText: 'Option - 2',
                ),
                if (_numberOfChoices > 2)
                  CreatePollTextField(
                    controller: widget.controller3,
                    onSubmitted: (String text) {},
                    hintText: 'Option - 3',
                  ),
                if (_numberOfChoices > 3)
                  CreatePollTextField(
                    controller: widget.controller4,
                    onSubmitted: (String text) {},
                    hintText: 'Option - 4',
                  ),
              ],
            ),
            commonDivider,
            LocaleKeys.add_option
                .tr()
                .toUpperCase()
                .toSubTitle2(
                  color: _numberOfChoices == 4
                      ? Colors.blueAccent.shade100
                      : AppColors.colorPrimary,
                  fontWeight:
                      _numberOfChoices == 4 ? FontWeight.w100 : FontWeight.w700,
                  fontSize: 12,
                  fontFamily1: 'CeraPro',
                )
                .toHorizontalPadding(2)
                .toOutlinedBorder(
                  _numberOfChoices < 4
                      ? () => setState(() {
                            _numberOfChoices++;
                          })
                      : null,
                  borderColor: _numberOfChoices == 4
                      ? Colors.blueAccent.shade100
                      : AppColors.colorPrimary,
                )
                .toContainer(
                  height: 30,
                )
          ],
        ),
      ),
    );
  }
}
