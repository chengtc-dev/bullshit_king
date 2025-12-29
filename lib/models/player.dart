import 'dart:math';

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

  /// 玩家頭像 (Emoji)
  final String avatar;

  /// 玩家當前分配的角色 (可為 null，表示尚未分配)
  Role? role;

  /// 玩家當前分數
  int score;

  /// 可用頭像列表
  static const List<String> avatars = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯',
    '🦁', '🐮', '🐷', '🐸', '🐵', '🐔', '🐧', '🐦', '🐺', '🐗',
    '🦄', '🐙', '👽', '🤖', '🎃', '👻', '🤡', '💩', '👺', '👹', '👿',
  ];

  /// 建構子
  Player({
    required this.id,
    required this.name,
    required this.avatar,
    this.role,
    this.score = 0,
  });

  /// 建立新玩家的工廠方法
  ///
  /// [name] 玩家名稱
  /// [avatar] 指定頭像 (若未提供則隨機選取)
  /// 會自動產生一個基於時間戳記的 ID
  factory Player.create({required String name, String? avatar}) {
    final random = Random();
    return Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // 暫時使用時間戳作為 ID
      name: name,
      avatar: avatar ?? avatars[random.nextInt(avatars.length)],
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
