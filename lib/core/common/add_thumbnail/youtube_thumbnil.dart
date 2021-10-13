// library simple_url_preview;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:html/dom.dart' as htmlDom;
import 'package:html/parser.dart';
import 'package:simple_url_preview/widgets/preview_description.dart';
// import 'package:simple_url_preview/widgets/preview_image.dart';
// import 'package:simple_url_preview/widgets/preview_site_name.dart';
import 'package:simple_url_preview/widgets/preview_title.dart';
import 'package:string_validator/string_validator.dart';
import 'package:auto_route/auto_route.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Provides URL preview
class SimpleUrlPreview extends StatefulWidget {
  /// URL for which preview is to be shown
  final String url;

  /// Height of the preview
  final double previewHeight;

  /// Whether or not to show close button for the preview
  final bool isClosable;

  /// Background color
  final Color bgColor;

  /// Style of Title.
  final TextStyle titleStyle;

  /// Number of lines for Title. (Max possible lines = 2)
  final int titleLines;

  /// Style of Description
  final TextStyle descriptionStyle;

  /// Number of lines for Description. (Max possible lines = 3)
  final int descriptionLines;

  /// Style of site title
  final TextStyle siteNameStyle;

  /// Color for loader icon shown, till image loads
  final Color imageLoaderColor;

  /// Container padding
  final EdgeInsetsGeometry previewContainerPadding;

  /// onTap URL preview, by default opens URL in default browser
  final VoidCallback onTap;

  final bool homePagePostCreate;
  final Function clearText;

  final PostEntity postEntity;
  final Function onClickAction;

  SimpleUrlPreview(
      {@required this.url,
      this.previewHeight = 130.0,
      this.isClosable,
      this.bgColor,
      this.titleStyle,
      this.titleLines = 2,
      this.descriptionStyle,
      this.descriptionLines = 3,
      this.siteNameStyle,
      this.imageLoaderColor,
      this.previewContainerPadding,
      this.onTap,
      this.homePagePostCreate = false,
      this.clearText,
      this.postEntity,
      this.onClickAction})
      : assert(previewHeight >= 130.0,
            'The preview height should be greater than or equal to 130'),
        assert(titleLines <= 2 && titleLines > 0,
            'The title lines should be less than or equal to 2 and not equal to 0'),
        assert(descriptionLines <= 3 && descriptionLines > 0,
            'The description lines should be less than or equal to 3 and not equal to 0');

  @override
  _SimpleUrlPreviewState createState() => _SimpleUrlPreviewState();
}

class _SimpleUrlPreviewState extends State<SimpleUrlPreview> {
  Map _urlPreviewData;
  bool _isVisible = true;
  bool _isClosable;
  double _previewHeight;
  TextStyle _titleStyle;
  TextStyle _descriptionStyle;
  TextStyle _siteNameStyle;
  Color _imageLoaderColor;
  EdgeInsetsGeometry _previewContainerPadding;
  VoidCallback _onTap;

  bool isVideoPlay = false;
  //widget.homePagePostCreate true close icon show : -

  @override
  void initState() {
    super.initState();
    _getUrlData();
  }

  @override
  void didUpdateWidget(SimpleUrlPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getUrlData();
  }

  void _initialize() {
    _previewHeight = widget.previewHeight;
    _descriptionStyle = widget.descriptionStyle;
    _titleStyle = widget.titleStyle;
    _siteNameStyle = widget.siteNameStyle;
    _previewContainerPadding = widget.previewContainerPadding;
    _onTap = widget.onTap ?? _launchURL;
  }

  void _getUrlData() async {
    if (!isURL(widget.url)) {
      setState(() {
        _urlPreviewData = null;
      });
      return;
    }

    var response = await DefaultCacheManager()
        .getSingleFile(widget.url)
        .catchError((error) {
      return null;
    });
    if (response == null) {
      if (!this.mounted) {
        return;
      }
      setState(() {
        _urlPreviewData = null;
      });
      return;
    }

    var document = parse(await response.readAsString());

    Map data = {};
    _extractOGData(document, data, 'og:title');
    _extractOGData(document, data, 'og:description');
    _extractOGData(document, data, 'og:site_name');
    _extractOGData(document, data, 'og:image');

    if (!this.mounted) {
      return;
    }

    if (data != null && data.isNotEmpty) {
      setState(() {
        _urlPreviewData = data;
        _isVisible = true;
      });
    }
  }

  void _extractOGData(htmlDom.Document document, Map data, String parameter) {
    var titleMetaTag = document.getElementsByTagName("meta")?.firstWhere(
        (meta) => meta.attributes['property'] == parameter,
        orElse: () => null);
    if (titleMetaTag != null) {
      data[parameter] = titleMetaTag.attributes['content'];
    }
  }

  void _launchURL() async {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (c) => StatefulBuilder(builder: (context, setState) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: AppColors.alertBg.withOpacity(0.5),
                child: SafeArea(
                    child: Stack(
                  children: [
                    Align(
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
                          child:
                              Icon(Icons.close, color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          YoutubePlayer(
                            controller: _controller,
                            liveUIColor: Colors.grey,
                          ),
                          Container(
                            height: 35,
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    widget.onClickAction(0);
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      setState(() {});
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 0),
                                          child: Image(
                                              height: 20,
                                              width: 20,
                                              image: AssetImage(
                                                  "images/png_image/white_message.png"),
                                              color: Color(0xFFFFFFFF))),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0, left: 5),
                                          child: Text(
                                              widget?.postEntity
                                                      ?.commentCount ??
                                                  "0",
                                              style: const TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontFamily: "CeraPro",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14)))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.onClickAction(1);
                                    Future.delayed(Duration(milliseconds: 50),
                                        () {
                                      setState(() {});
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 0),
                                          child: Image(
                                              height: 20,
                                              width: 20,
                                              image: AssetImage(widget
                                                          ?.postEntity
                                                          ?.isLiked ??
                                                      false
                                                  ? "images/png_image/heart.png"
                                                  : "images/png_image/white_like.png"),
                                              color:
                                                  widget?.postEntity?.isLiked ??
                                                          false
                                                      ? Colors.red
                                                      : Color(0xFFFFFFFF))),
                                      // ? AppIcons.heartIcon(color: Colors.red)
                                      // : AppIcons.likeIcon(color: const Color(0xFF737880))),

                                      Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0, left: 5),
                                          child: Text(
                                              widget?.postEntity?.likeCount ??
                                                  "0",
                                              style: TextStyle(
                                                  color: widget?.postEntity
                                                              ?.isLiked ??
                                                          false
                                                      ? Colors.red
                                                      : Color(0xFFFFFFFF),
                                                  fontFamily: "CeraPro",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14)))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.onClickAction(2);
                                    ExtendedNavigator.root.pop();
                                    // Future.delayed(Duration(milliseconds: 300), () {
                                    //   // setState(() {});
                                    // });
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 0),
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
                                          padding: const EdgeInsets.only(
                                              bottom: 0, left: 5),
                                          child: Text(
                                              widget?.postEntity?.repostCount ??
                                                  "0",
                                              style: TextStyle(
                                                  color: widget?.postEntity
                                                              ?.isReposted ??
                                                          false
                                                      ? AppColors.alertBg
                                                      : Color(0xFFFFFFFF),
                                                  fontFamily: "CeraPro",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14)))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.onClickAction(3);
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      setState(() {});
                                    });
                                  },
                                  child: const Image(
                                      height: 20,
                                      width: 20,
                                      image: const AssetImage(
                                          "images/png_image/white_share.png"),
                                      color: const Color(0xFFFFFFFF)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    _isClosable = widget.isClosable ?? false;
    _imageLoaderColor =
        widget.imageLoaderColor ?? Theme.of(context).accentColor;
    _initialize();

    if (_urlPreviewData == null || !_isVisible) return SizedBox();

    return Container(
      padding: _previewContainerPadding,
      height: _previewHeight,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _onTap,
            child: _buildPreviewCard(context),
          ),
          _buildClosablePreview(),
          widget.homePagePostCreate
              ? Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      // _onTap();
                      widget.clearText();
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.only(right: 20, top: 5),
                      decoration: BoxDecoration(
                          color: AppColors.twitterBlue, shape: BoxShape.circle),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 15),
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                    onTap: () {
                      _onTap();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      margin: EdgeInsets.only(top: 60),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildClosablePreview() {
    return _isClosable
        ? Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.clear,
              ),
              onPressed: () {
                setState(() {
                  _isVisible = false;
                });
              },
            ),
          )
        : SizedBox();
  }

  _buildPreviewCard(BuildContext context) {
    return Container(
      // elevation: 5,
      margin: EdgeInsets.only(
          left: widget.homePagePostCreate ? 70 : 0,
          right: widget.homePagePostCreate ? 15 : 0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: PreviewImage(
            _urlPreviewData['og:image'],
            _imageLoaderColor,
          )),
          Container(
            height: 85,
            padding: EdgeInsets.all(8),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PreviewTitle(
                  _urlPreviewData['og:title'],
                  _titleStyle == null
                      ? const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontFamily: "CeraPro",
                          color: Colors.black,
                        )
                      : _titleStyle,
                  1,
                  // _titleLines
                ),
                PreviewDescription(
                  _urlPreviewData['og:description'],
                  _descriptionStyle == null
                      ? const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )
                      : _descriptionStyle,
                  2,

                  // _descriptionLines,
                ),
                PreviewSiteName(
                  widget.url,
                  // _urlPreviewData['og:site_name'],
                  _siteNameStyle == null
                      ? TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).accentColor,
                        )
                      : _siteNameStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows site name of URL
class PreviewSiteName extends StatelessWidget {
  final String _siteName;
  final TextStyle _textStyle;

  PreviewSiteName(this._siteName, this._textStyle);

  @override
  Widget build(BuildContext context) {
    if (_siteName == null) {
      return SizedBox();
    }

    return Text(
      _siteName,
      textAlign: TextAlign.left,
      maxLines: 2,
      style: _textStyle,
    );
  }
}

/// Shows image of URL
class PreviewImage extends StatelessWidget {
  final String _image;
  final Color _imageLoaderColor;

  PreviewImage(this._image, this._imageLoaderColor);

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: CachedNetworkImage(
          imageUrl: _image,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
          errorWidget: (context, url, error) => Icon(
            Icons.error,
            color: _imageLoaderColor,
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  height: 20,
                  width: 20,
                  margin: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            ],
          ),
          /* progressIndicatorBuilder: (context, url, downloadProgress) => Icon(
            Icons.more_horiz,
            color: _imageLoaderColor,
          ),*/
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
