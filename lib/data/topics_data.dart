import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
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
      final String response = await rootBundle.loadString('assets/data/topics.json');
      final List<dynamic> data = json.decode(response);
      topics = data.map((json) => Topic.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading topics: $e');
      // 發生錯誤時保持空列表或載入預設資料 (這裡保留空列表)
      topics = [];
    }
  }
}
