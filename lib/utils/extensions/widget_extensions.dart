import 'package:flutter/widgets.dart';

extension $PageControllerExt on PageController {
  int get pageIndex {
    if (hasClients && positions.isNotEmpty && position.hasPixels && position.hasContentDimensions) {
      return page?.round() ?? 0;
    } else {
      return 0;
    }
  }
}
