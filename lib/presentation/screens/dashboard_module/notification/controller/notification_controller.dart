import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/notification_model.dart';

enum NotificationTab { all, unread, read }

class NotificationController extends GetxController {
  var searchController = TextEditingController();

  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  // Selected tab index (0 = All, 1 = Unread, 2 = Read)
  Rx<NotificationTab> selectedTab = NotificationTab.all.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationData();
  }


  void fetchNotificationData() async {
    notificationList.clear();
    try {
      final data = await loadListFromAsset<NotificationModel>(
        AppJsonPath.notificationData,
        'notificationList',
            (json) => NotificationModel.fromJson(json),
      );
      notificationList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notificationList: $e');
      }
    }
  }


  void changeTab(int index) {
    switch (index) {
      case 1:
        selectedTab.value = NotificationTab.read;
        break;
      case 2:
        selectedTab.value = NotificationTab.unread;
        break;
      case 0:
      default:
        selectedTab.value = NotificationTab.all;
    }
  }
  /// Get filtered list based on selected tab
  List<NotificationModel> get currentTabList {
    switch (selectedTab.value) {
      case NotificationTab.unread:
        return notificationList.where((e) => !e.read).toList();
      case NotificationTab.read:
        return notificationList.where((e) => e.read).toList();
      case NotificationTab.all:
      return notificationList;
    }
  }

  /// Mark a notification as read (optional helper)
  // void markAsRead(int id) {
  //   int index = notificationList.indexWhere((e) => e.id == id);
  //   if (index != -1) {
  //     notificationList[index] = notificationList[index].copyWith(read: true);
  //   }
  // }
  //
  // /// Mark a notification as unread (optional helper)
  // void markAsUnread(int id) {
  //   int index = notificationList.indexWhere((e) => e.id == id);
  //   if (index != -1) {
  //     notificationList[index] = notificationList[index].copyWith(read: false);
  //   }
  // }
}
