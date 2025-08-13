import 'dart:convert';

import 'package:flutter/services.dart';

Future<T> loadJsonFromAsset<T>(
    String path, T Function(Map<String, dynamic>) fromJson) async {
  final String response = await rootBundle.loadString(path);
  final data = json.decode(response) as Map<String, dynamic>;
  return fromJson(data);
}

Future<List<T>> loadListFromAsset<T>(
    String path,
    String listKey,
    T Function(Map<String, dynamic>) fromJson,
    ) async {
  final String response = await rootBundle.loadString(path);
  final data = json.decode(response) as Map<String, dynamic>;

  final list = data[listKey] as List<dynamic>;
  return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
}
