import 'dart:math';
import 'package:uuid/uuid.dart';

/// 遊戲角色枚舉
enum Role {
  /// 想想：負責猜測誰是老實人
  thinker,

  /// 老實人：知道題目與正確解釋
  honest,

  /// 瞎掰人：不知道題目，需瞎掰解釋
  bullshitter,
}

/// 玩家模型類
///
/// 儲存玩家的基本資訊、角色以及分數
class Player {
  /// 玩家唯一識別碼
  final String id;

  /// 玩家名稱
  final String name;

  /// 玩家頭像顏色 (Hex)
  final int color;

  /// 玩家當前分配的角色 (可為 null，表示尚未分配)
  Role? role;

  /// 玩家當前分數
  int score;

  /// 可用頭像顏色列表 (深色背景下的明亮顏色)
  static const List<int> avatarColors = [
    0xFFF44336, // 紅
    0xFFE91E63, // 粉
    0xFF9C27B0, // 紫
    0xFF673AB7, // 深紫
    0xFF3F51B5, // 靛
    0xFF2196F3, // 藍
    0xFF03A9F4, // 淺藍
    0xFF00BCD4, // 青
    0xFF009688, // 綠
    0xFF4CAF50, // 亮綠
    0xFF8BC34A, // 萊姆
    0xFFCDDC39, // 黃
    0xFFFFEB3B, // 亮黃
    0xFFFFC107, // 琥珀
    0xFFFF9800, // 橘
    0xFFFF5722, // 深橘
    0xFF795548, // 褐
    0xFF9E9E9E, // 灰
    0xFF607D8B, // 藍灰
  ];

  /// 建構子
  Player({
    required this.id,
    required this.name,
    required this.color,
    this.role,
    this.score = 0,
  });

  /// 建立新玩家的工廠方法
  ///
  /// [name] 玩家名稱
  /// [color] 指定頭像顏色 (若未提供則隨機選取)
  /// 使用 UUID 確保 ID 的唯一性
  factory Player.create({required String name, int? color}) {
    const uuid = Uuid();
    final random = Random();
    return Player(
      id: uuid.v4(),
      name: name,
      color: color ?? avatarColors[random.nextInt(avatarColors.length)],
    );
  }

  /// 重置玩家角色
  ///
  /// 在新的一局開始前調用
  void resetRole() {
    role = null;
  }

  /// 增加分數
  ///
  /// [points] 要增加的分數
  void addScore(int points) {
    score += points;
  }
}
