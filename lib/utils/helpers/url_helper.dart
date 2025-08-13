import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'package:url_launcher/url_launcher.dart' show LaunchMode;

Future<bool> launchBrowserUrl(String url,
    [LaunchMode launchMode = LaunchMode.externalApplication]) async {
  final Uri encodedUri = Uri.parse(Uri.encodeFull(url).toString());
  var canLaunch = await canLaunchUrlString(encodedUri.toString());
  if (canLaunch) {
    launchUrlString(url, mode: launchMode)
        .whenComplete(() => debugPrint("launchUrl -> $encodedUri"));
  }
  return canLaunch;
}
