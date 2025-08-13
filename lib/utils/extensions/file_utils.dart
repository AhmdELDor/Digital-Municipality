import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../presentation/common_widgets/alerts/alerts.dart';
import '/core/constants/app_strings.dart';


class FileUtils {
  static Future<bool> downloadFile(
    BuildContext context,
    String url,
    Map<String, dynamic> queryParameters,
    String fileName,
  ) async {
    try {
      final Directory? downloadDir =
          (Platform.isAndroid
              ? await getExternalStorageDirectory() //FOR ANDROID
              : await getApplicationDocumentsDirectory());
      if (downloadDir == null) {
        showErrorMessage(
          context: context,
          title: 'Could not access downloads directory',
          content: "",
        );
        return false;
      }
      // Create a new directory with the desired name
      String folderName = "${AppStrings.appName} Invoice";
      String folderPath = '${downloadDir.path}/$folderName';
      Directory newFolder = Directory(folderPath);
      if (!newFolder.existsSync()) {
        newFolder.createSync(recursive: true);
      }
      // Create the file path within the new directory
      final String filePath = '$folderPath/$fileName';
      // Download the file
      // await ApiClients()
      //     .download(url, filePath, queryParameters: queryParameters);
      if (kDebugMode) {
        print('File downloaded to $filePath');
      }
      showSuccessMessage(
        context: context,
        title: "Invoice Download",
        content: "Your invoice has been downloaded successfully!",
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
      showErrorMessage(
        context: context,
        title: 'Error downloading file: $e',
        content: "",
      );
      return false;
    }
  }
}
