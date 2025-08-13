import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/app_strings.dart';
import 'permission_app_dialog.dart';

class PermissionHelper {
  final BuildContext context;
  final Permission permission;
  final String permissionName;
  final IconData icon;
  final String description;

  const PermissionHelper({
    required this.context,
    required this.permission,
    required this.permissionName,
    required this.icon,
    required this.description,
  });

  factory PermissionHelper.camera(BuildContext context) {
    return PermissionHelper(
      context: context,
      permission: Permission.camera,
      icon: Icons.camera_alt_outlined,
      description:
          "We will access camera to take and upload image for user profile & verification document.",
      permissionName: "Camera",
    );
  }

  factory PermissionHelper.storage(BuildContext context) {
    return PermissionHelper(
      context: context,
      permission: Permission.storage,
      icon: Icons.sd_storage_outlined,
      description:
          "We will access storage to select and upload image for user profile & verification document.",
      permissionName: "Storage",
    );
  }
  factory PermissionHelper.manageExternalStorage(BuildContext context) {
    return PermissionHelper(
      context: context,
      permission: Permission.manageExternalStorage,
      icon: Icons.sd_storage_sharp,
      description:
          "We will access storage to select and upload image for user profile & verification document.",
      permissionName: "Manage External Storage",
    );
  }

  factory PermissionHelper.photos(BuildContext context) {
    return PermissionHelper(
      context: context,
      permission: Permission.photos,
      icon: Icons.photo_library_outlined,
      description:
          "We will access photos to select and upload image for user profile & verification document.",
      permissionName: "Photos",
    );
  }

  factory PermissionHelper.notification(BuildContext context) {
    return PermissionHelper(
      context: context,
      permission: Permission.notification,
      icon: Icons.notifications_outlined,
      description:
          "We will keep you updated with latest updates and send your account information timely through the push notifications.",
      permissionName: "Notifications",
    );
  }

  factory PermissionHelper.microphone(BuildContext context) {
    return PermissionHelper(
      context: context,
      permission: Permission.microphone,
      icon: Icons.mic_rounded,
      description:
          "We will access microphone to listen your voice for voice feature",
      permissionName: "Microphone",
    );
  }

  factory PermissionHelper.videos(BuildContext context) {
    return PermissionHelper(
      context: context,
      permission: Permission.mediaLibrary,
      icon: Icons.video_library_sharp,
      description:
          "We will access videos to listen your voice for voice feature",
      permissionName: "Video",
    );
  }

  factory PermissionHelper.location(BuildContext context) {
    return PermissionHelper(
      context: context,
      permission: Permission.location,
      icon: Icons.location_pin,
      description: PermissionStrings.descLocationPermission,
      permissionName: PermissionStrings.locationPermission,
    );
  }

  Future<bool> checkService() async {
    final permission = this.permission;
    if (permission is! PermissionWithService) return false;
    final status = await permission.serviceStatus;
    return status == ServiceStatus.enabled;
  }

  Future<bool> get hasPermission => permission.isGranted;

  Future<PermissionResult> requestPermission() async {
    final status = await permission.request();
    return _getPermissionResult(status);
  }

  Future<PermissionResult> checkPermission() async {
    final status = await permission.status;
    return _getPermissionResult(status);
  }

  void onPermissionDenied() {
    showDialog(
      context: context,
      builder: (context) => PermissionAppDialog(
        title: "Permission Denied !",
        subTitle:
            "You have permanently denied for $permissionName permission. To enable $permissionName permission, you need to go to settings and allow us to access $permissionName.",
        positiveButton: AppDialogButton(
          label: "Open Settings",
          onPressed: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
        ),
        negativeButton: const AppDialogButton(label: "Cancel", onPressed: null),
      ),
    );
  }

  PermissionResult _getPermissionResult(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.denied => PermissionResult.denied,
      PermissionStatus.granted ||
      PermissionStatus.provisional =>
        PermissionResult.granted,
      PermissionStatus.limited =>
        Platform.isIOS ? PermissionResult.granted : PermissionResult.denied,
      PermissionStatus.restricted ||
      PermissionStatus.permanentlyDenied =>
        PermissionResult.permanentlyDenied,
    };
  }

  Future<bool> resolvePermission() async {
    final isDenied =
        await permission.isDenied || await permission.isPermanentlyDenied;
    if (isDenied) {
      final request = await requestPermission();
      if (request == PermissionResult.granted) {
        return true;
      } else if (request == PermissionResult.denied) {
        onPermissionDenied();
        return false;
      } else if (request == PermissionResult.limited) {
        onPermissionDenied();
        return false;
      } else if (request == PermissionResult.permanentlyDenied) {
        onPermissionDenied();
        return false;
      } else {
        onPermissionDenied();
        return false;
      }
    }
    return true;
  }
}

enum PermissionResult { denied, granted, permanentlyDenied, limited }
