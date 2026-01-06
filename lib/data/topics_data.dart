import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/topic.dart';

/// 題目資料類
///
/// 包含遊戲中使用的所有題目及其定義
class TopicsData {
  /// 靜態題目列表
  ///
  /// 包含 [Topic] 物件的列表，這些資料將從 JSON 載入
  static List<Topic> topics = [];

  /// 從 JSON 檔案載入題目
  static Future<void> loadTopics() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/topics.json',
      );
      final dynamic decodedData = json.decode(response);
      if (decodedData is List) {
        topics = decodedData
            .map((item) => Topic.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint('JSON data is not a list');
        topics = [];
      }
    } catch (e) {
      debugPrint('Error loading topics: $e');
      // 發生錯誤時保持空列表或載入預設資料 (這裡保留空列表)
      topics = [];
    }
  }
}
