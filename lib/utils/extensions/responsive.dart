import 'package:flutter/material.dart';

/// by displaying specific widgets for mobile, tablet, and desktop layouts.
class ResponsiveView extends StatelessWidget {
  /// Widget to show for mobile screens (320px - 767px).
  final Widget mobile;

  /// Optional widget to show for tablet screens (768px - 1024px).
  final Widget? tablet;

  /// Widget to show for desktop screens (1025px and above).
  final Widget desktop;

  const ResponsiveView(
      {super.key, required this.mobile, this.tablet, required this.desktop});

  /// Constructor to initialize the widgets for each screen size.

  /// Static helper method to check if the current screen is a mobile device.
  /// Returns `true` if the screen width is less than 767px.
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 767;

  /// Static helper method to check if the current screen is a tablet device.
  /// Returns `true` if the screen width is between 768px and 1024px.
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024 &&
      MediaQuery.of(context).size.width >= 768;

  /// Static helper method to check if the current screen is a desktop device.
  /// Returns `true` if the screen width is 1025px or greater.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1025;

  /// Static helper method to check if the screen is a small desktop (between 1024 and 1200).
  static bool isSmallDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024 &&
          MediaQuery.of(context).size.width < 1200;


  @override
  Widget build(BuildContext context) {
    // Get the size of the current screen using MediaQuery.
    final Size size = MediaQuery.of(context).size;

    // Check the screen width and return the appropriate widget:
    if (size.width >= 1025) {
      // If the screen width is 1025px or larger, show the desktop widget.
      return desktop;
    } else if (size.width >= 768 && tablet != null) {
      // If the screen width is between 768px and 1024px, show the tablet widget.
      // Only display this if the tablet widget is provided (not null).
      return tablet!;
    } else {
      // For all other screen sizes (below 768px), show the mobile widget.
      return mobile;
    }
  }

/*
xs	Extra small (0–575 px)	Mobile portrait. Typically phones.
sm	Small (576–767 px)	Mobile landscape or small tablets.
md	Medium (768–991 px)	Tablets.
lg	Large (992–1199 px)	Small laptops.
xl	Extra large (1200+ px)	Large desktops or high-res displays.*/

}
