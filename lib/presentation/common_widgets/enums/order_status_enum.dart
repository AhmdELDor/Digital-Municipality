
import 'package:flutter/material.dart';


enum OrderStatus {
  ordered,
  pending,
  processing,
  shipped,
  outForDelivery,
  yetToBeDelivered,
  delivered,
  cancelled,
  returned,
  failed,
  appliedForExchange
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.ordered:
        return "Ordered";
    case OrderStatus.appliedForExchange:
        return "Applied For Exchange";
     case OrderStatus.pending:
        return "Pending";
      case OrderStatus.processing:
        return "Processing";
      case OrderStatus.shipped:
        return "Shipped";
      case OrderStatus.delivered:
        return "Delivered";
      case OrderStatus.cancelled:
        return "Cancelled";
      case OrderStatus.returned:
        return "Returned";
      case OrderStatus.failed:
        return "Failed";
      case OrderStatus.outForDelivery:
        return "Out for Delivery";
      case OrderStatus.yetToBeDelivered:
        return "Yet to be Delivered";
    }
  }

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == status.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }

  // Example: add a color for status badge
  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Color(0xffEEEFF2);
      case OrderStatus.processing:
        return Color(0xffEEEFF2);
      case OrderStatus.shipped:
        return Color(0xffEEEFF2);
      case OrderStatus.delivered:
        return Color(0xff043000);
      case OrderStatus.cancelled:
      case OrderStatus.failed:
        return Color(0xffD4D5D9);
      case OrderStatus.returned:
        return Color(0xffEEEFF2);
      case OrderStatus.ordered:
        return Color(0xffEEEFF2);
      case OrderStatus.outForDelivery:
        return Color(0xffEEEFF2);
      case OrderStatus.yetToBeDelivered:
        return Color(0xffEEEFF2);
      case OrderStatus.appliedForExchange:
        return Color(0xffEEEFF2);
    }
  }

  // Example: add a color for status badge
  Color get iconColor {
    switch (this) {
      case OrderStatus.pending:
        return Color(0xff1F2937);
      case OrderStatus.processing:
        return Color(0xff1F2937);
      case OrderStatus.shipped:
        return Color(0xff1F2937);
      case OrderStatus.delivered:
        return Color(0xffFFFFFF);
      case OrderStatus.cancelled:
      case OrderStatus.failed:
        return Color(0xff292D32);
      case OrderStatus.returned:
        return Color(0xff1F2937);
      case OrderStatus.ordered:
        return Color(0xff1F2937);
      case OrderStatus.outForDelivery:
        return Color(0xff1F2937);
      case OrderStatus.yetToBeDelivered:
        return Color(0xff1F2937);
      case OrderStatus.appliedForExchange:
        return Color(0xff292D32);
    }
  }

 /* String get icon {
    switch (this) {
      case OrderStatus.pending:
        return AppCommonIcon.boxIcon;
      case OrderStatus.processing:
        return AppCommonIcon.boxIcon;
      case OrderStatus.shipped:
        return AppCommonIcon.boxIcon;
      case OrderStatus.delivered:
        return AppCommonIcon.boxIcon;
      case OrderStatus.cancelled:
      case OrderStatus.failed:
        return AppCommonIcon.closeIcon;
      case OrderStatus.returned:
        return AppCommonIcon.boxIcon;
      case OrderStatus.ordered:
        return AppCommonIcon.boxIcon;
      case OrderStatus.outForDelivery:
        return AppCommonIcon.truckTickIcon;
      case OrderStatus.yetToBeDelivered:
        return AppCommonIcon.truckTickIcon;
      case OrderStatus.appliedForExchange:
        return AppCommonIcon.backSquareIcon;
    }
  }*/

}
