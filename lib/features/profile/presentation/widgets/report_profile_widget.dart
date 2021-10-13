import '../../../../core/common/buttons/custom_button.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/datasource/local_data_source.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_bar.dart';
import '../../../authentication/data/models/login_response.dart';
import '../../domain/entity/report_profile_entity.dart';
import '../bloc/profile_cubit.dart';
import '../../../../translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_select/smart_select.dart';
import '../../../../core/theme/colors.dart';
import '../../../feed/presentation/bloc/feed_cubit.dart';
import 'package:flutter/cupertino.dart';
import '../../../../extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportProfileWidget extends StatefulWidget {
  const ReportProfileWidget(this.userId, {Key key}) : super(key: key);
  final String userId;
  @override
  _ReportProfileWidgetState createState() => _ReportProfileWidgetState();
}

class _ReportProfileWidgetState extends State<ReportProfileWidget> {
  final Map<int, String> reportMap = {
    1: LocaleKeys.this_is_spam.tr(),
    2: LocaleKeys.misleading_or_fraudulent.tr(),
    3: LocaleKeys.publication_of_private_information.tr(),
    4: LocaleKeys.threats_of_violence_or_physical_harm.tr(),
    5: LocaleKeys.i_am_not_interested_in_this_post.tr(),
    6: 'Other',
  };
  int currentIndex = 1;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FeedCubit, CommonUIState>(
        bloc: getIt.get<FeedCubit>(),
        builder: (context, state) => state.maybeWhen(
          orElse: () => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: [
                ListTile(
                  leading: const BackButton(),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Report Post',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  tileColor: AppColors.sfBgColor,
                ),
                14.toSizedBox,
                SmartSelect<String>.single(
                  modalFilter: true,
                  modalFilterBuilder: (ctx, cont) => TextField(
                    decoration: InputDecoration(
                      hintStyle: context.subTitle1
                          .copyWith(fontWeight: FontWeight.w600),
                      hintText: "Search Report Reason",
                      border: InputBorder.none,
                    ),
                    onChanged: (s) => cont.apply(s),
                  ),
                  choiceStyle: S2ChoiceStyle(
                    titleStyle: context.subTitle2.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // title
                  modalConfig: S2ModalConfig(
                    title: LocaleKeys.report_post.tr(),
                    headerStyle: S2ModalHeaderStyle(
                      textStyle: context.subTitle1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  modalType: S2ModalType.fullPage,
                  value: reportMap[currentIndex],
                  onChange: (s) {
                    setState(() {
                      currentIndex = int.tryParse(s.value);
                    });
                  },

                  // Tile before choice
                  tileBuilder: (c, s) => ListTile(
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 14,
                    ),
                    onTap: () => s.showModal(),
                    title: 'Report Reason'
                        .toSubTitle2(fontWeight: FontWeight.w600),
                    subtitle: reportMap[currentIndex]
                        .toCaption(fontWeight: FontWeight.w600),
                  ),
                  choiceItems: reportMap.entries
                      .map(
                        (e) => S2Choice(
                          value: e.key.toString(),
                          title: e.value,
                        ),
                      )
                      .toList(),
                ),
                14.toSizedBox,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    maxLength: 300,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.toVertical,
                        horizontal: 6.toHorizontal,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.red.withOpacity(.8),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: .8,
                          color: Colors.red.withOpacity(.8),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AppColors.placeHolderColor,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AppColors.colorPrimary,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      labelText: 'Comment',
                      labelStyle: AppTheme.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.placeHolderColor),
                      errorStyle: AppTheme.caption.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  text: 'Report Post',
                  onTap: () async {
                    // send api requestt with report int and comment
                    print(
                        'Send Api Request with $currentIndex , and ${_controller.text}');
                    final UserAuth _userAuth =
                        await getIt.get<LocalDataSource>().getUserAuth();
                    final String _sessionId = _userAuth.authToken;

                    await getIt.get<ProfileCubit>().reportProfile(
                          ReportProfileEntity(
                            sessionId: _sessionId,
                            userId: widget.userId,
                            reason: currentIndex,
                            comment: _controller.text,
                          ),
                        );
                  },
                  color: AppColors.colorPrimary,
                ).toPadding(16),
              ].toColumn(
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ),
          loading: () => LoadingBar(),
        ),
      ),
    );
  }
}
