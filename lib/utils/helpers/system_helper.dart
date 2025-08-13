import 'package:flutter/services.dart';

Future<void> copyToClipboard(String value) {
  return Clipboard.setData(ClipboardData(text: value));
}

Future<String?> getClipboardContent() async {
  var data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text;
}
