import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../common/add_thumbnail/check_link.dart';
import '../common/add_thumbnail/web_link_show.dart';
import '../common/add_thumbnail/youtube_thumbnil.dart';
import '../theme/colors.dart';
import 'MediaOpener.dart';
import 'thumbnail_widget.dart';
import '../../features/feed/domain/entity/post_entity.dart';
import '../../features/feed/domain/entity/post_media.dart';
import '../../features/feed/presentation/widgets/create_post_card.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import '../../extensions.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomSlider extends StatefulWidget {
  final PostEntity postEntity;
  final bool isOnlySocialLink;
  final bool isComeHome;

  final List<PostMedia> mediaItems;
  final bool dialogView;
  final int currentIndex;
  final Function onClickAction;
  final ogData;
  // final OgDataClass1  ogData;

  const CustomSlider(
      {Key key,
      this.onClickAction,
      this.postEntity,
      this.isOnlySocialLink,
      this.mediaItems,
      this.dialogView = false,
      this.currentIndex = 0,
      this.ogData,
      this.isComeHome})
      : super(key: key);
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  int _current = 0;
  PageController pageController;

  final ValueNotifier<int> _pageNotifier = new ValueNotifier<int>(0);
  PageController _pageController = PageController();

  PageController _pageControllerClick;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    _current = widget.currentIndex;
    pageController = PageController(initialPage: widget.currentIndex);
    _pageControllerClick = PageController(initialPage: currentPage);

    if (widget.mediaItems != null && widget.mediaItems.length != 0) {
      print(widget.mediaItems[0].mediaType == MediaTypeEnum.IMAGE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightSet(),
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      child: showPostWiseData(),
    );
  }

  heightSet() {
    if (widget?.postEntity?.ogData != null &&
        widget.postEntity.ogData != "" &&
        (widget.postEntity.ogData["image"] == null ||
            widget.postEntity.ogData["image"] == "") &&
        widget.postEntity.ogData["url"] != null &&
        widget.postEntity.ogData["url"] != "") {
      return 135.0;
    } else {
      if (widget.isOnlySocialLink) {
        return 230.0;
      } else {
        if (widget.mediaItems != null && widget.mediaItems.length != 0) {
          print(widget.mediaItems[0].mediaType == MediaTypeEnum.VIDEO);
          if (widget.mediaItems[0].mediaType == MediaTypeEnum.VIDEO) {
            return 135.0;
          } else {
            return 160.0;
          }
        } else {
          return 160.0;
        }
      }
    }
  }

  showPostWiseData() {
    String description = "";

    if (widget?.ogData != null && widget?.ogData != "") {
      description = widget?.ogData['url'] ?? "";
    }

    String linkGet = "";

    if (widget.ogData != null) {
      String convertLink1 = CheckLink.checkYouTubeLink(description);

      print("vishal <><><<><><><> $convertLink1");

      if (convertLink1 != null) {
        String convertLink = convertLink1.replaceAll("\n", " ");

        List d1 = [];

        if (convertLink != null) {
          d1 = convertLink?.split(" ") ?? "";
        } else {
          d1.add(description ?? "");
        }

        print("Vishal .,.,.,.,.,.,.,.,  $d1");

        d1.forEach((element) {
          if (element.contains("https://www.youtube.com") ||
              element.contains("https://youtu.be") ||
              element.contains("https://m.youtube.com/") ||
              element.contains("www.youtube.com")) {
            linkGet = element;
          } else if (element.contains("https://") || element.contains("www.")) {
            linkGet = element;
          } else {
            print("no data");
            // linkGet = "";
          }
        });
      }
    }

    if (widget?.postEntity?.ogData != null &&
        widget.postEntity.ogData != "" &&
        (widget.postEntity.ogData["image"] == null ||
            widget.postEntity.ogData["image"] == "") &&
        widget.postEntity.ogData["url"] != null &&
        widget.postEntity.ogData["url"] != "") {
      return imageNotShow();
    } else if (linkGet.contains("https://www.youtube.com") ||
        linkGet.contains("https://youtu.be") ||
        linkGet.contains("https://m.youtube.com/") ||
        linkGet.contains("www.youtube.com")) {
      return SimpleUrlPreview(
        url: CheckLink.checkYouTubeLink(linkGet) ?? "",
        previewHeight: 200,
        previewContainerPadding: EdgeInsets.all(0),
        homePagePostCreate: false,
        postEntity: widget.postEntity,
        onClickAction: (index) {
          print(index);
          widget.onClickAction(index);
          Future.delayed(Duration(milliseconds: 50), () {
            setState(() {});
          });
        },
      );
    } else if (linkGet.contains("https://www.youtube")) {
      return Container(
        height: 100,
        width: 300,
        child: Text("No Youtube data found",
            style: TextStyle(color: Colors.blueAccent)),
      );
    } else if (linkGet.contains("https://") || linkGet.contains("www.")) {
      return SimpleUrlPreviewWeb(
        url: CheckLink.checkYouTubeLink(linkGet) ?? "",
        // textColor: Colors.white,
        bgColor: Colors.red,
        isClosable: false,
        previewHeight: 180,
        homePagePostCreate: false,
      );
    } else {
      return showGrid(widget?.mediaItems?.length ?? 0);
    }
  }

  showGrid(int length) {
    if (length == 1) {
      return Container(
        decoration: const BoxDecoration(
            // color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(35))),
        child: gridData(0, length),
      );
    } else if (length == 2) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget?.mediaItems?.length ?? 0,
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                      // color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: twoImageShow(index, widget?.mediaItems?.length),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  print("Hello vishal $index");
                  _current = index;
                  _pageNotifier.value = index;
                  _pageControllerClick = PageController(initialPage: index);
                });
              },
            ),
            Container(
              height: 6,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                  right: 5,
                  top: 10,
                  left: MediaQuery.of(context).size.width / 1.65),
              alignment: Alignment.centerRight,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ListView.builder(
                  controller: _pageController,
                  itemCount: widget?.mediaItems?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 6,
                      width: _current == index ? 20 : 12,
                      child: Container(
                        height: 6,
                        width: _current == index ? 20 : 12,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // shape: BoxShape.circle,
                          color: _current == index
                              ? Color(0xFF1D88F0)
                              : Color(0xFF1D88F0).withOpacity(0.7),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    } else if (length == 3 || length >= 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 1,
              child: Container(
                height: 160,
                // width: MediaQuery.of(context).size.width / 3,
                // height: double.infinity,
                margin: EdgeInsets.only(right: 0),
                decoration: const BoxDecoration(
                    // color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        bottomLeft: Radius.circular(35))),
                child: gridData(0, length),
              )),
          Flexible(
              flex: 1,
              child: Column(children: [
                Container(
                  height: 79,
                  decoration: const BoxDecoration(
                      // color: Colors.black,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(35))),
                  child: gridData(1, length),
                ),
                Container(
                  height: 79,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: const BoxDecoration(
                      // color: Colors.black,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(35))),
                  child: gridData(2, length),
                ),
              ]))
        ],
      );
    } else {
      return Container();
    }
  }

  twoImageShow(int itemIndex, int length) {
    if (widget.mediaItems[itemIndex].mediaType == MediaTypeEnum.IMAGE) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: CachedNetworkImage(
              imageUrl: widget.mediaItems[itemIndex].url,
              width: context.getScreenWidth,
              height: 180,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (_, ___, progress) {
                Vx.teal100;
                return const CircularProgressIndicator()
                    .toPadding(8)
                    .toCenter();
              })).toHorizontalPadding(0).onTapWidget(() {
        if (!widget.dialogView) showMediaSlider(itemIndex, length);
      });
    } else if (widget.mediaItems[itemIndex].mediaType == MediaTypeEnum.VIDEO) {
      GlobalKey<MyVideoPlayerState> videoKey = GlobalKey();
      return ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: MyVideoPlayer(
            withAppBar: false,
            key: videoKey,
            path: widget.mediaItems[itemIndex].url),
      ).onTapWidget(() {
        videoKey.currentState.pause();
        showAnimatedDialog(
            barrierDismissible: true,
            context: context,
            builder: (c) => MyVideoPlayer(
                path: widget.mediaItems[itemIndex].url,
                withAppBar: false,
                fullVideoControls: true));
      });
    } else if (widget.mediaItems[itemIndex].mediaType == MediaTypeEnum.GIF) {
      return GiphyWidget(
        path: widget.mediaItems[itemIndex].url,
        enableClose: false,
      ).toContainer(color: Colors.red);
    } else if (widget.mediaItems[itemIndex].mediaType == MediaTypeEnum.EMOJI) {
      return GiphyWidget(
        path: widget.mediaItems[itemIndex].url,
      ).toContainer(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)));
    }
  }

  Widget getListView() {
    return ExpandablePageView(
      children: List<Widget>.generate(widget.mediaItems.length, (itemIndex) {
        switch (widget.mediaItems[itemIndex].mediaType) {
          case MediaTypeEnum.IMAGE:
            return ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: CachedNetworkImage(
                    imageUrl: widget.mediaItems[itemIndex].url,
                    width: context.getScreenWidth,
                    height: 180,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (_, ___, progress) {
                      Vx.teal100;
                      return const CircularProgressIndicator()
                          .toPadding(8)
                          .toCenter();
                    })).toHorizontalPadding(4).onTapWidget(() {
              if (!widget.dialogView)
                showAnimatedDialog(
                    alignment: Alignment.center,
                    context: context,
                    builder: (c) => Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              // fit: StackFit.passthrough,
                              children: [
                                CustomSlider(
                                  mediaItems: widget.mediaItems,
                                  dialogView: true,
                                  currentIndex: _current,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      child: CloseButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          ExtendedNavigator.root.pop();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                            .makeScrollable()
                            .toContainer(
                                height: context.getScreenHeight,
                                alignment: Alignment.center)
                            .toSafeArea,
                    barrierDismissible: true);
            });
            break;
          case MediaTypeEnum.VIDEO:
            GlobalKey<MyVideoPlayerState> videoKey = GlobalKey();
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: MyVideoPlayer(
                withAppBar: false,
                key: videoKey,
                path: widget.mediaItems[itemIndex].url,
              ),
            ).onTapWidget(() {
              videoKey.currentState.pause();
              showAnimatedDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (c) => MyVideoPlayer(
                      path: widget.mediaItems[itemIndex].url,
                      withAppBar: false,
                      fullVideoControls: true));
            });
            break;
          case MediaTypeEnum.GIF:
            return GiphyWidget(
              path: widget.mediaItems[itemIndex].url,
              enableClose: false,
            ).toContainer(color: Colors.red);
            break;
          case MediaTypeEnum.EMOJI:
            return GiphyWidget(
              path: widget.mediaItems[itemIndex].url,
            ).toContainer(
                height: 150,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)));
            break;
          default:
            return Container();
        }
      }),
      controller: pageController,
    );
  }

  gridData(int itemIndex, int length) {
    if (widget.mediaItems == null || widget.mediaItems.length == 0) {
      return Container();
    } else {
      if (widget.mediaItems[itemIndex].mediaType == MediaTypeEnum.IMAGE) {
        return ClipRRect(
            borderRadius: boarderRadiusCheck(itemIndex, length),
            child: CachedNetworkImage(
                imageUrl: widget.mediaItems[itemIndex].url,
                width: context.getScreenWidth,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, ___, progress) {
                  Vx.teal100;
                  return const CircularProgressIndicator()
                      .toPadding(8)
                      .toCenter();
                })).toHorizontalPadding(1).onTapWidget(() {
          print("cureenty index show $itemIndex");

          _pageControllerClick = PageController(initialPage: itemIndex);

          setState(() {});
          if (!widget.dialogView) showMediaSlider(itemIndex, length);
        });
      } else if (widget.mediaItems[itemIndex].mediaType ==
          MediaTypeEnum.VIDEO) {
        GlobalKey<MyVideoPlayerState> videoKey = GlobalKey();

        return ClipRRect(
          borderRadius: boarderRadiusCheck(itemIndex, length),
          child: MyVideoPlayer(
            withAppBar: false,
            key: videoKey,
            path: widget.mediaItems[itemIndex].url,
            isComeHome: widget.isComeHome,
          ),
        ).onTapWidget(() {
          videoKey.currentState.pause();

          showMediaSlider(itemIndex, length);
        });
      } else if (widget.mediaItems[itemIndex].mediaType == MediaTypeEnum.GIF) {
        return GiphyWidget(
          path: widget.mediaItems[itemIndex].url,
          enableClose: false,
          itemIndex: itemIndex,
          length: length,
        ).toContainer(color: Colors.red);
      } else if (widget.mediaItems[itemIndex].mediaType ==
          MediaTypeEnum.EMOJI) {
        return GiphyWidget(
          path: widget.mediaItems[itemIndex].url,
          itemIndex: itemIndex,
          length: length,
        ).toContainer(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)));
      } else {
        return Container();
      }
    }
  }

  boarderRadiusCheck(int itemIndex, int length) {
    if (length == 1) {
      return BorderRadius.circular(35);
    } else if (length == 2) {
      if (itemIndex == 0) {
        return const BorderRadius.only(
            topLeft: Radius.circular(35), bottomLeft: Radius.circular(35));
      } else {
        return const BorderRadius.only(
            topRight: Radius.circular(35), bottomRight: Radius.circular(35));
      }
    } else if (length == 3 || length >= 3) {
      if (itemIndex == 0) {
        return const BorderRadius.only(
            topLeft: Radius.circular(35), bottomLeft: Radius.circular(35));
      } else if (itemIndex == 1) {
        return const BorderRadius.only(topRight: Radius.circular(35));
      } else {
        return const BorderRadius.only(bottomRight: Radius.circular(35));
      }
    } else if (length == 4) {
      if (itemIndex == 0) {
        return const BorderRadius.only(topLeft: Radius.circular(35));
      } else if (itemIndex == 1) {
        return const BorderRadius.only(bottomLeft: Radius.circular(35));
      } else if (itemIndex == 2) {
        return const BorderRadius.only(topRight: Radius.circular(35));
      } else {
        return const BorderRadius.only(bottomRight: Radius.circular(35));
      }
    } else {
      return BorderRadius.circular(40);
    }
  }

  showMediaSlider(int itemIndex, int length) {
    GlobalKey<MyVideoPlayerState> videoAlertKey = GlobalKey();
    videoAlertKey?.currentState?.isPlaying = false;

    bool isArrowShow = true;
    bool isVideoPlay = true;

    return showAnimatedDialog(
        alignment: Alignment.center,
        context: context,
        builder: (c) => Column(
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.mediaItems[itemIndex].mediaType ==
                                MediaTypeEnum.IMAGE) {
                              isArrowShow = !isArrowShow;
                              setState(() {});
                            } else {
                              isVideoPlay = !isVideoPlay;
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.alertBg.withOpacity(0.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(top: 0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            PageView.builder(
                                              itemCount: length ?? 0,
                                              controller: _pageControllerClick,
                                              onPageChanged: (int index) {
                                                currentPage = index;
                                                setState(() {});
                                              },
                                              itemBuilder: (context, index) {
                                                return widget
                                                            .mediaItems[
                                                                itemIndex]
                                                            .mediaType ==
                                                        MediaTypeEnum.VIDEO
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ModelVideoPlayer(
                                                              path: widget
                                                                  .mediaItems[
                                                                      itemIndex]
                                                                  .url),
                                                          Container(
                                                            height: 35,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 5),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    widget
                                                                        .onClickAction(
                                                                            0);
                                                                    Future.delayed(
                                                                        Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {
                                                                      setState(
                                                                          () {});
                                                                    });
                                                                  },
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  0),
                                                                          child: Image(
                                                                              height: 20,
                                                                              width: 20,
                                                                              image: AssetImage("images/png_image/white_message.png"),
                                                                              color: Color(0xFFFFFFFF))),
                                                                      Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              bottom:
                                                                                  0,
                                                                              left:
                                                                                  5),
                                                                          child: Text(
                                                                              widget?.postEntity?.commentCount ?? "0",
                                                                              style: const TextStyle(color: Color(0xFFFFFFFF), fontFamily: "CeraPro", fontWeight: FontWeight.w400, fontSize: 14)))
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    widget
                                                                        .onClickAction(
                                                                            1);
                                                                    Future.delayed(
                                                                        Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {
                                                                      setState(
                                                                          () {});
                                                                    });
                                                                  },
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  0),
                                                                          child: Image(
                                                                              height: 20,
                                                                              width: 20,
                                                                              image: AssetImage(widget?.postEntity?.isLiked ?? false ? "images/png_image/heart.png" : "images/png_image/white_like.png"),
                                                                              color: widget?.postEntity?.isLiked ?? false ? Colors.red : Color(0xFFFFFFFF))),
                                                                      Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              bottom:
                                                                                  0,
                                                                              left:
                                                                                  5),
                                                                          child: Text(
                                                                              widget?.postEntity?.likeCount ?? "0",
                                                                              style: TextStyle(color: widget?.postEntity?.isLiked ?? false ? Colors.red : Color(0xFFFFFFFF), fontFamily: "CeraPro", fontWeight: FontWeight.w400, fontSize: 14)))
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    widget
                                                                        .onClickAction(
                                                                            2);
                                                                    Future.delayed(
                                                                        Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {
                                                                      ExtendedNavigator
                                                                          .root
                                                                          .pop();
                                                                      setState(
                                                                          () {});
                                                                      // 456123
                                                                    });
                                                                  },
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  0),
                                                                          child: Image(
                                                                              height: 20,
                                                                              width: 20,
                                                                              image: AssetImage(widget?.postEntity?.isReposted ?? false ? "images/png_image/blur_share.png" : "images/png_image/white_repost.png"))),
                                                                      Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              bottom:
                                                                                  0,
                                                                              left:
                                                                                  5),
                                                                          child: Text(
                                                                              widget?.postEntity?.repostCount ?? "",
                                                                              style: TextStyle(color: widget?.postEntity?.isReposted ?? false ? AppColors.alertBg : Color(0xFFFFFFFF), fontFamily: "CeraPro", fontWeight: FontWeight.w400, fontSize: 14)))
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Image(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        image: const AssetImage(
                                                                            "images/png_image/white_share.png"),
                                                                        color: const Color(
                                                                            0xFFFFFFFF))
                                                                    .toPadding(
                                                                        0)
                                                                    .onTapWidget(
                                                                        () {
                                                                  widget
                                                                      .onClickAction(
                                                                          3);
                                                                  Future.delayed(
                                                                      Duration(
                                                                          milliseconds:
                                                                              300),
                                                                      () {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                })
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: widget
                                                            .mediaItems[index]
                                                            .url,
                                                        height:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2,
                                                        width: context
                                                            .getScreenWidth,
                                                        fit: BoxFit.fitWidth,
                                                        progressIndicatorBuilder:
                                                            (_, ___, progress) {
                                                          Vx.teal100;
                                                          return const CircularProgressIndicator()
                                                              .toPadding(8)
                                                              .toCenter();
                                                        });
                                              },
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                length == 1 || !isArrowShow
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          if (currentPage !=
                                                              0) {
                                                            currentPage =
                                                                currentPage - 1;

                                                            _pageControllerClick.animateToPage(
                                                                currentPage,
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            400),
                                                                curve: Curves
                                                                    .easeInOut);
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 35,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.blue
                                                                .withOpacity(
                                                                    0.4),
                                                          ),
                                                          child: const Icon(
                                                              Icons
                                                                  .arrow_back_sharp,
                                                              color:
                                                                  Colors.white,
                                                              size: 20),
                                                        ),
                                                      ),
                                                length == 1 || !isArrowShow
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          if (widget.mediaItems
                                                                      .length -
                                                                  1 !=
                                                              currentPage) {
                                                            currentPage =
                                                                currentPage + 1;

                                                            _pageControllerClick.animateToPage(
                                                                currentPage,
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            400),
                                                                curve: Curves
                                                                    .easeInOut);
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 35,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.blue
                                                                .withOpacity(
                                                                    0.4),
                                                          ),
                                                          child: const Icon(
                                                              Icons
                                                                  .arrow_forward_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 20),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ))),
                                widget.mediaItems[itemIndex].mediaType ==
                                        MediaTypeEnum.VIDEO
                                    ? Container()
                                    : Container(
                                        height: 35,
                                        margin: EdgeInsets.only(top: 0),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                widget.onClickAction(0);
                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () {
                                                  setState(() {});
                                                });
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Image(
                                                          height: 20,
                                                          width: 20,
                                                          image: AssetImage(
                                                              "images/png_image/white_message.png"),
                                                          color: Color(
                                                              0xFFFFFFFF))),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              left: 5),
                                                      child: Text(
                                                          widget?.postEntity
                                                                  ?.commentCount ??
                                                              "0",
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontFamily:
                                                                  "CeraPro",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14)))
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                widget.onClickAction(1);
                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () {
                                                  setState(() {});
                                                });
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Image(
                                                          height: 20,
                                                          width: 20,
                                                          image: AssetImage(widget
                                                                      ?.postEntity
                                                                      ?.isLiked ??
                                                                  false
                                                              ? "images/png_image/heart.png"
                                                              : "images/png_image/white_like.png"),
                                                          color: widget
                                                                      ?.postEntity
                                                                      ?.isLiked ??
                                                                  false
                                                              ? Colors.red
                                                              : Color(
                                                                  0xFFFFFFFF))),
                                                  // ? AppIcons.heartIcon(color: Colors.red)
                                                  // : AppIcons.likeIcon(color: const Color(0xFF737880))),

                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              left: 5),
                                                      child: Text(
                                                          widget?.postEntity
                                                                  ?.likeCount ??
                                                              "0",
                                                          style: TextStyle(
                                                              color: widget
                                                                          ?.postEntity
                                                                          ?.isLiked ??
                                                                      false
                                                                  ? Colors.red
                                                                  : Color(
                                                                      0xFFFFFFFF),
                                                              fontFamily:
                                                                  "CeraPro",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14)))
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                widget.onClickAction(2);

                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () {
                                                  ExtendedNavigator.root.pop();
                                                  setState(() {});
                                                  // 456123
                                                });
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Image(
                                                          height: 20,
                                                          width: 20,
                                                          image: AssetImage(widget
                                                                      ?.postEntity
                                                                      ?.isReposted ??
                                                                  false
                                                              ? "images/png_image/blur_share.png"
                                                              : "images/png_image/white_repost.png"))),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              left: 5),
                                                      child: Text(
                                                          widget?.postEntity
                                                                  ?.repostCount ??
                                                              "",
                                                          style: TextStyle(
                                                              color: widget
                                                                          ?.postEntity
                                                                          ?.isReposted ??
                                                                      false
                                                                  ? AppColors
                                                                      .alertBg
                                                                  : Color(
                                                                      0xFFFFFFFF),
                                                              fontFamily:
                                                                  "CeraPro",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14)))
                                                ],
                                              ),
                                            ),
                                            const Image(
                                                    height: 20,
                                                    width: 20,
                                                    image: const AssetImage(
                                                        "images/png_image/white_share.png"),
                                                    color:
                                                        const Color(0xFFFFFFFF))
                                                .toPadding(0)
                                                .onTapWidget(() {
                                              widget.onClickAction(3);
                                              Future.delayed(
                                                  Duration(milliseconds: 300),
                                                  () {
                                                setState(() {});
                                              });
                                            })
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                        !isArrowShow
                            ? Container()
                            : SafeArea(
                                child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    ExtendedNavigator.root.pop();
                                  },
                                  child: Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.4),
                                    ),
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 30),
                                  ),
                                ),
                              )),
                      ],
                    );
                  },
                )
              ],
            ));

    // return  ;
  }

  imageNotShow() {
    return Container(
      height: 130,
      width: 250,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.sfBgColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              CheckLink.removeHtmlTag(widget?.postEntity?.ogData["title"]) ??
                  "Page not found!",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                fontFamily: "CeraPro",
                color: Colors.black,
              ),
              maxLines: 1),
          const SizedBox(height: 5),
          Text(
              CheckLink.removeHtmlTag(
                      widget?.postEntity?.ogData["description"]) ??
                  "Page not found!",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                fontFamily: "CeraPro",
                color: AppColors.greyText,
              ),
              maxLines: 2),
          const SizedBox(height: 5),
          Text(
              CheckLink.removeHtmlTag(widget?.postEntity?.ogData["url"]) ??
                  "Page link not found!",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: "CeraPro",
                color: Theme.of(context).accentColor,
              ),
              maxLines: 2),
        ],
      ),
    );
  }
}
