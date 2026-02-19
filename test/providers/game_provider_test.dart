import 'package:bullshit_king/data/topics_data.dart';
import 'package:bullshit_king/models/game_state.dart';
import 'package:bullshit_king/models/player.dart';
import 'package:bullshit_king/providers/game_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 為了在測試中能成功載入 assets (如 topics.json), 需要先初始化 binding
  TestWidgetsFlutterBinding.ensureInitialized();

  // 在所有測試開始前，確保題目已經從檔案載入
  setUpAll(() async {
    await TopicsData.loadTopics();
  });

  group('GameProvider 測試', () {
    late GameProvider gameProvider;

    // 每個測試前都重新初始化 GameProvider
    setUp(() {
      gameProvider = GameProvider();
    });

    test('初始狀態應為設定階段', () {
      expect(gameProvider.currentPhase, GamePhase.setup);
      expect(gameProvider.players, isEmpty);
      expect(gameProvider.canStartGame, isFalse);
    });

    test('可以新增和移除玩家', () {
      gameProvider.addPlayer('玩家一');
      expect(gameProvider.players.length, 1);
      expect(gameProvider.players.first.name, '玩家一');
      expect(gameProvider.players.first.color, isA<int>());

      final playerId = gameProvider.players.first.id;
      gameProvider.removePlayer(playerId);
      expect(gameProvider.players, isEmpty);
    });

    test('少於 3 位玩家時無法開始遊戲', () {
      gameProvider.addPlayer('玩家一');
      gameProvider.addPlayer('玩家二');
      expect(gameProvider.canStartGame, isFalse);

      gameProvider.startGame(); // 嘗試開始
      expect(gameProvider.currentPhase, GamePhase.setup); // 應維持在設定階段
    });

    test('擁有 3 位以上玩家時可以開始遊戲', () {
      gameProvider.addPlayer('玩家一');
      gameProvider.addPlayer('玩家二');
      gameProvider.addPlayer('玩家三');
      expect(gameProvider.canStartGame, isTrue);
    });

    group('遊戲流程測試 (有 4 位玩家)', () {
      setUp(() {
        gameProvider.addPlayer('A');
        gameProvider.addPlayer('B');
        gameProvider.addPlayer('C');
        gameProvider.addPlayer('D');
        gameProvider.startGame();
      });

      test('startGame 應正確分配角色並進入揭示階段', () {
        expect(gameProvider.currentPhase, GamePhase.reveal);
        expect(gameProvider.currentTopic, isNotNull);

        final roles = gameProvider.players.map((p) => p.role).toList();
        expect(roles.where((r) => r == Role.thinker).length, 1);
        expect(roles.where((r) => r == Role.honest).length, 1);
        expect(roles.where((r) => r == Role.bullshitter).length, 2);

        expect(gameProvider.thinker, isNotNull);
        expect(gameProvider.currentPlayerIndex, 0);
      });

      test('nextPlayerReveal 應切換玩家，直到進入討論階段', () {
        expect(gameProvider.currentPlayerIndex, 0);

        gameProvider.nextPlayerReveal(); // -> 1
        expect(gameProvider.currentPlayerIndex, 1);

        gameProvider.nextPlayerReveal(); // -> 2
        expect(gameProvider.currentPlayerIndex, 2);

        gameProvider.nextPlayerReveal(); // -> 3
        expect(gameProvider.currentPlayerIndex, 3);

        // 最後一位玩家查看完畢後，進入討論階段
        gameProvider.nextPlayerReveal();
        expect(gameProvider.currentPhase, GamePhase.discuss);
      });

      test('startVoting 應進入投票階段', () {
        // 先走完揭示流程
        gameProvider.nextPlayerReveal();
        gameProvider.nextPlayerReveal();
        gameProvider.nextPlayerReveal();
        gameProvider.nextPlayerReveal();

        gameProvider.startVoting();
        expect(gameProvider.currentPhase, GamePhase.vote);
      });

      test('submitVote - 猜對老實人，分數應正確計算', () {
        final thinker = gameProvider.players.firstWhere(
          (p) => p.role == Role.thinker,
        );
        final honest = gameProvider.players.firstWhere(
          (p) => p.role == Role.honest,
        );

        final initialThinkerScore = thinker.score;
        final initialHonestScore = honest.score;

        gameProvider.submitVote(honest);

        expect(gameProvider.currentPhase, GamePhase.result);
        expect(thinker.score, initialThinkerScore + 2);
        expect(honest.score, initialHonestScore + 2);
      });

      test('submitVote - 猜錯老實人，分數應正確計算', () {
        final thinker = gameProvider.players.firstWhere(
          (p) => p.role == Role.thinker,
        );
        final bullshitter = gameProvider.players.firstWhere(
          (p) => p.role == Role.bullshitter,
        );

        final initialThinkerScore = thinker.score;
        final initialBullshitterScore = bullshitter.score;

        gameProvider.submitVote(bullshitter);

        expect(gameProvider.currentPhase, GamePhase.result);
        expect(thinker.score, initialThinkerScore); // 想想分數不變
        expect(bullshitter.score, initialBullshitterScore + 2); // 被誤認的瞎掰人 +2
      });

      test('nextRound 應重置遊戲狀態但保留玩家和分數', () {
        final playerBefore = gameProvider.players.first;
        playerBefore.addScore(5);
        final scoreBefore = playerBefore.score;

        gameProvider.submitVote(gameProvider.players.last); // 進入結果
        gameProvider.nextRound();

        expect(gameProvider.currentPhase, GamePhase.setup);
        expect(gameProvider.players.length, 4); // 玩家仍在
        expect(gameProvider.players.first.score, scoreBefore); // 分數保留
        expect(gameProvider.currentTopic, isNull);
        expect(gameProvider.thinker, isNull);
        expect(gameProvider.honest, isNull);
      });
    });
  });
}
