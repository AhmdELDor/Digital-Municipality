import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> cacheDirectory() async {
  final directory = await getTemporaryDirectory();
  return _checkAndCreateDir(directory);
}

Future<String> downloadDirectory() async {
  final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
  return _checkAndCreateDir(directory!);
}

Future<String> _checkAndCreateDir(Directory directory) async {
  bool hasExisted = await directory.exists();
  if (!hasExisted) directory = await directory.create();
  return directory.path;
}
