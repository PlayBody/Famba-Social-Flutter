import '../../../../core/di/injection.dart';
import '../../../../core/theme/colors.dart';
import '../../../feed/presentation/bloc/feed_cubit.dart';
import '../../../feed/presentation/widgets/create_post_card.dart';
import '../../domain/entiity/reply_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../extensions.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_compress/video_compress.dart';

class CreatePost extends StatefulWidget {
  final String title;
  final String replyTo;
  final String threadId;
  final ReplyEntity replyEntity;
  final Function backData;
  const CreatePost(
      {Key key,
      this.title = "Create Post",
      this.replyTo = "",
      this.threadId,
      this.replyEntity,
      this.backData})
      : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    if (VideoCompress.compressProgress$.notSubscribed) {
      listenVideoStream();
    } else {
      VideoCompress.dispose();
      listenVideoStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return WillPopScope(
      onWillPop: () {
        FocusManager.instance.primaryFocus.unfocus();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: widget.title.toSubTitle1(
                color: AppColors.textColor, fontWeight: FontWeight.bold),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
          body: BlocProvider(
              create: (c) => getIt<FeedCubit>(),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CreatePostCard(
                      threadId: widget.threadId,
                      replyEntity: widget.replyEntity,
                      backData: widget.backData,
                    ),
                  ],
                ).makeScrollable(),
              )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // FocusScope.of(context).requestFocus(FocusNode());
    VideoCompress.dispose();
    super.dispose();
  }

  void listenVideoStream() {
    VideoCompress.compressProgress$.subscribe((progress) {
      if (progress < 99.99)
        EasyLoading.showProgress(
          (progress / 100),
          status: 'Compressing ${progress.toInt()}%',
        );
      else
        EasyLoading.dismiss();
    });
  }
}
