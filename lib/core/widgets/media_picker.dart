import 'dart:io';

import 'package:auto_route/auto_route.dart';
import '../theme/colors.dart';
import '../../features/feed/presentation/widgets/create_post_card.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../extensions.dart';

openMediaPicker(
  BuildContext context,
  StringToVoidFunc onMediaSelected, {
  MediaTypeEnum mediaType = MediaTypeEnum.IMAGE,
  bool allowCropping = false,
}) async {
  XFile pickedFile;
  Permission permission;
  if (Platform.isIOS) {
    permission = Permission.photos;
  } else {
    permission = Permission.storage;
  }
  PermissionStatus currentStatus = await permission.status;
  if (currentStatus.isGranted) {
    context.showAlertDialog(widgets: [
      "Camera"
          .toSubTitle2(color: AppColors.colorPrimary)
          .toFlatButton(() async {
        // Navigator.of(context).pop();
        ExtendedNavigator.root.pop();
        if (mediaType == MediaTypeEnum.IMAGE) {
          pickedFile = await ImagePicker().pickImage(
            source: ImageSource.camera,
            imageQuality: 50,
          );
          final media = await pickedFile.path.compressImage();
          if (media != null) {
            if (allowCropping) {
              final file = await _cropImage(media.path);
              onMediaSelected(file.path);
            } else
              onMediaSelected(media.path);
          }
        } else {
          pickedFile =
              await ImagePicker().pickVideo(source: ImageSource.camera);

          /// no need to compress video for ios
          if (Platform.isAndroid) {
            var videoFile = await pickedFile?.path?.compressVideo;
            onMediaSelected(videoFile?.path);
          } else
            onMediaSelected(pickedFile.path);
        }
      }),
      "Gallery"
          .toSubTitle2(color: AppColors.colorPrimary)
          .toFlatButton(() async {
        // Navigator.of(context).pop();
        ExtendedNavigator.root.pop();
        if (mediaType == MediaTypeEnum.IMAGE) {
          pickedFile = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 50,
          );
          final media = await pickedFile?.path?.compressImage();
          if (media != null) {
            if (allowCropping) {
              final file = await _cropImage(media.path);
              onMediaSelected(file.path);
            } else
              onMediaSelected(pickedFile.path);
          }
        } else {
          pickedFile = await ImagePicker().pickVideo(
            source: ImageSource.gallery,
          );
          if (Platform.isAndroid) {
            var videoFile = await pickedFile?.path?.compressVideo;
            onMediaSelected(videoFile?.path);
          } else
            onMediaSelected(pickedFile.path);
        }
      }),
    ], title: "Choose media type");
  } else
    await _requestPermission(context, permission);
}

_requestPermission(BuildContext context, Permission permission) async {
  if (Platform.isIOS)
    context.showOkCancelAlertDialog(
        okButtonTitle: "Open",
        desc: "Open app settings to grant permission",
        title: "Confirmation",
        onTapOk: () async {
          ExtendedNavigator.root.pop();
          await [permission, Permission.camera, Permission.storage].request();
          await openAppSettings();
        });
  else
    await [permission, Permission.camera, Permission.storage].request();
// await openAppSettings();
}

Future<File> _cropImage(String path) async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 1),
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColors.colorPrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      iosUiSettings: const IOSUiSettings(
        title: 'Image Picker',
      ));
  return croppedFile;
}
