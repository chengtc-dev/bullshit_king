import 'dart:math';

import 'package:flutter/material.dart';

import '../data/topics_data.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/topic.dart';

/// 遊戲狀態管理類 (Provider)
///
/// 負責管理遊戲的核心邏輯、狀態流轉和分數計算
class GameProvider extends ChangeNotifier {
  final Random _random = Random();

  /// 玩家列表
  final List<Player> _players = [];

  /// 當前遊戲階段
  GamePhase _currentPhase = GamePhase.setup;

  /// 當前題目
  Topic? _currentTopic;

  /// 當前正在查看身份的玩家索引 (用於 Reveal 階段)
  int _currentPlayerIndex = 0;

  /// 擔任「想想」的玩家
  Player? _thinker;

  /// 擔任「老實人」的玩家
  Player? _honest;

  // --- Getters ---

  /// 取得所有玩家
  List<Player> get players => _players;

  /// 取得當前階段
  GamePhase get currentPhase => _currentPhase;

  /// 取得當前題目
  Topic? get currentTopic => _currentTopic;

  /// 取得當前操作玩家索引
  int get currentPlayerIndex => _currentPlayerIndex;

  /// 取得當前操作玩家物件
  Player? get currentPlayer =>
      _players.isNotEmpty && _currentPlayerIndex < _players.length
      ? _players[_currentPlayerIndex]
      : null;

  /// 取得「想想」玩家
  Player? get thinker => _thinker;

  /// 取得「老實人」玩家
  Player? get honest => _honest;

  // --- 設定相關方法 ---

  /// 新增玩家
  ///
  /// [name] 玩家名稱
  void addPlayer(String name) {
    // 找出尚未被使用的頭像顏色
    final usedColors = _players.map((p) => p.color).toSet();
    final availableColors = Player.avatarColors
        .where((c) => !usedColors.contains(c))
        .toList();

    final int color;
    if (availableColors.isNotEmpty) {
      // 從可用顏色中隨機選取
      color = availableColors[_random.nextInt(availableColors.length)];
    } else {
      // 如果所有顏色都用光了，則從全部顏色中隨機選取
      color = Player.avatarColors[_random.nextInt(Player.avatarColors.length)];
    }

    _players.add(Player.create(name: name, color: color));
    notifyListeners();
  }

  /// 移除玩家
  ///
  /// [id] 玩家 ID
  void removePlayer(String id) {
    _players.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  /// 檢查是否可以開始遊戲
  ///
  /// 至少需要 3 位玩家
  bool get canStartGame => _players.length >= 3;

  // --- 遊戲流程方法 ---

  /// 開始遊戲
  ///
  /// 分配角色、選擇題目並進入揭示階段
  /// [category] 可選的題目分類
  /// [specificTopic] 指定的題目 (若提供則優先於 category)
  void startGame({String? category, Topic? specificTopic}) {
    if (!canStartGame) return;

    _assignRoles();
    _pickTopic(category, specificTopic);
    _currentPhase = GamePhase.reveal;
    _currentPlayerIndex = 0;
    notifyListeners();
  }

  /// 分配角色 (內部方法)
  ///
  /// 隨機分配 1 位想想、1 位老實人，其餘為瞎掰人
  void _assignRoles() {
    // 重置所有玩家角色
    for (var p in _players) {
      p.resetRole();
    }

    // 隨機打亂玩家列表以分配角色
    final shuffledPlayers = List<Player>.from(_players)..shuffle(_random);

    // 分配想想 (第一位)
    _thinker = shuffledPlayers[0];
    _thinker!.role = Role.thinker;

    // 分配老實人 (第二位)
    _honest = shuffledPlayers[1];
    _honest!.role = Role.honest;

    // 分配瞎掰人 (其餘)
    for (int i = 2; i < shuffledPlayers.length; i++) {
      shuffledPlayers[i].role = Role.bullshitter;
    }
  }

  /// 選擇題目 (內部方法)
  ///
  /// 從題庫中隨機選擇一個題目
  void _pickTopic(String? category, Topic? specificTopic) {
    // 如果有指定題目，直接使用
    if (specificTopic != null) {
      _currentTopic = specificTopic;
      return;
    }

    List<Topic> availableTopics = TopicsData.topics;

    // 如果有指定分類且不是"全部"，則過濾
    if (category != null && category != '全部') {
      availableTopics = availableTopics
          .where((t) => t.category == category)
          .toList();
    }

    // 防呆：如果過濾後沒有題目，則使用所有題目
    if (availableTopics.isEmpty) {
      availableTopics = TopicsData.topics;
    }

    if (availableTopics.isNotEmpty) {
      _currentTopic = availableTopics[_random.nextInt(availableTopics.length)];
    }
  }

  /// 換下一位玩家查看身份
  ///
  /// 如果所有玩家都查看完畢，則進入討論階段
  void nextPlayerReveal() {
    if (_currentPlayerIndex < _players.length - 1) {
      _currentPlayerIndex++;
    } else {
      _currentPhase = GamePhase.discuss;
    }
    notifyListeners();
  }

  /// 開始投票
  ///
  /// 進入投票階段
  void startVoting() {
    _currentPhase = GamePhase.vote;
    notifyListeners();
  }

  /// 提交投票
  ///
  /// [selectedPlayer] 想想選擇的玩家
  /// 計算分數並進入結果階段
  void submitVote(Player selectedPlayer) {
    _calculateScore(selectedPlayer);
    _currentPhase = GamePhase.result;
    notifyListeners();
  }

  /// 計算分數 (內部方法)
  ///
  /// [selectedPlayer] 被指認的玩家
  void _calculateScore(Player selectedPlayer) {
    // 判斷是否猜對 (被選中的人是否為老實人)
    final bool isCorrect = selectedPlayer.role == Role.honest;

    if (isCorrect) {
      // 猜對：想想 +2，老實人 +2
      _thinker?.addScore(2);
      _honest?.addScore(2);
    } else {
      // 猜錯：被誤認的瞎掰人 +2
      selectedPlayer.addScore(2);
    }
  }

  /// 下一局
  ///
  /// 重置遊戲狀態回到設定階段 (保留玩家和分數)
  void nextRound() {
    _currentPhase = GamePhase.setup;
    _currentTopic = null;
    _thinker = null;
    _honest = null;
    notifyListeners();
  }
}
