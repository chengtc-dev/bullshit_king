import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../models/player.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'discussion_screen.dart';
import 'topic_selection_screen.dart';

/// 身份揭示畫面
///
/// 採用 Pass-and-Play 模式，讓玩家輪流查看自己的身份
class RevealScreen extends StatefulWidget {
  const RevealScreen({super.key});

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  /// 是否已揭示身份
  bool _isRevealed = false;

  /// 處理下一步按鈕點擊
  void _handleNext(GameProvider game) {
    if (_isRevealed) {
      // 如果已經揭示，則隱藏並換下一位
      setState(() {
        _isRevealed = false;
      });
      game.nextPlayerReveal();

      // 如果所有人都看過了，進入討論階段
      if (game.currentPhase == GamePhase.discuss) {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const DiscussionScreen(),
          ),
        );
      }
    } else {
      // 如果尚未揭示，則顯示身份
      setState(() {
        _isRevealed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Consumer<GameProvider>(
      builder: (context, game, child) {
        final player = game.currentPlayer;
        if (player == null) return const SizedBox(); // 防呆

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                AppTheme.deepPurple,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              if (!_isRevealed) ...[
                // 傳遞手機提示
                Icon(
                  Icons.phone_android,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ).animate().shake(duration: 500.ms),
                const SizedBox(height: 40),
                Text('請將手機傳給', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(player.color),
                  child: Text(
                    player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().scale(),
                const SizedBox(height: 20),
                Text(
                  player.name,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ).animate().scale(),
                const SizedBox(height: 40),
                const Text(
                  '確認周圍沒有其他人偷看',
                  style: TextStyle(color: Colors.white54),
                ),
              ] else ...[
                // 顯示身份內容
                _buildRoleContent(context, game, player),
              ],
              const Spacer(),
              // 下一步按鈕
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleNext(game),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRevealed
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    foregroundColor: _isRevealed ? Colors.white : Colors.black,
                  ),
                  child: Text(_isRevealed ? '我知道了 (換下一位)' : '查看身份'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    ),
  );

  /// 建立角色內容 Widget
  Widget _buildRoleContent(
    BuildContext context,
    GameProvider game,
    Player player,
  ) {
    String roleTitle = '';
    String description = '';
    Color color = Colors.white;
    IconData icon = Icons.help;

    // 根據角色設定顯示內容
    switch (player.role) {
      case Role.thinker:
        roleTitle = '你是「想想」';
        description = '你的任務是找出誰是老實人。\n仔細聽大家的解釋！';
        color = Colors.blueAccent;
        icon = Icons.psychology;
        break;
      case Role.honest:
        roleTitle = '你是「老實人」';
        description = '請閱讀以上正確解釋，\n並試著讓想想相信你。';
        color = Colors.greenAccent;
        icon = Icons.verified;
        break;
      case Role.bullshitter:
        roleTitle = '你是「瞎掰人」';
        description = '你不知道正確解釋。\n請發揮創意瞎掰一個解釋來誤導想想！';
        color = Colors.redAccent;
        icon = Icons.theater_comedy;
        break;
      default:
        break;
    }

    return Column(
      children: [
        Icon(icon, size: 80, color: color).animate().scale(duration: 400.ms),
        const SizedBox(height: 20),
        Text(
          roleTitle,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: color),
        ),
        const SizedBox(height: 30),
        // 題目卡片
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            children: [
              // 顯示分類 (所有人都看得到，作為瞎掰的提示)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  game.currentTopic?.category ?? '未分類',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '題目：${game.currentTopic?.term}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // 只有老實人看得到解釋
              if (player.role == Role.honest) ...[
                const Divider(height: 30),
                Text(
                  game.currentTopic?.definition ?? '',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 30),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        // 顯示重新開始按鈕
        ...[
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => _handleRestart(context, game),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('我知道題目意思 (換一題)'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white54,
              textStyle: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ],
    );
  }

  /// 處理重新開始下一輪
  void _handleRestart(BuildContext context, GameProvider game) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Center(
          child: Text(
            '確定換一題？',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        content: Text(
          '如果你已經知道題目意思，\n可以換一題重新開始。',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // 關閉對話框

              // 重新開始遊戲
              // 先重置揭示狀態
              setState(() {
                _isRevealed = false;
              });

              // 重新回到選擇題目畫面
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const TopicSelectionScreen(),
                ),
              );
            },
            child: const Text('確定換題'),
          ),
        ],
      ),
    );
  }
}
