import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'setup_screen.dart';

/// 結果畫面
///
/// 顯示正確答案、揭曉老實人身份以及玩家得分
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Consumer<GameProvider>(
      builder: (context, game, child) {
        final honest = game.players.firstWhere((p) => p.role == Role.honest);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.deepBlue,
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  '真相大白',
                  style: Theme.of(context).textTheme.displayMedium,
                ).animate().fadeIn().scale(),
                const SizedBox(height: 20),
                // 正確答案區塊
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '正確答案',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        game.currentTopic?.term ?? '',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        game.currentTopic?.definition ?? '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ).animate().slideY(begin: 0.2),
                const SizedBox(height: 30),
                // 揭曉老實人
                Text(
                  '老實人是...',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(honest.color),
                  child: Text(
                    honest.name.isNotEmpty ? honest.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().scale(delay: 500.ms).shake(delay: 1000.ms),
                Text(
                  honest.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.successColor,
                  ),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 30),
                const Divider(),
                // 玩家得分列表
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: game.players.length,
                    itemBuilder: (context, index) {
                      final player = game.players[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(player.color),
                          child: Text(
                            player.name.isNotEmpty
                                ? player.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(player.name),
                        subtitle: Text(_getRoleText(player.role)),
                        trailing: Text(
                          '${player.score} 分',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ).animate().fadeIn(delay: (1200 + index * 100).ms);
                    },
                  ),
                ),
                // 下一局按鈕
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        game.nextRound();
                        // 回到設定畫面 (保留玩家)
                        Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const SetupScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('下一局'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  /// 取得角色中文名稱
  String _getRoleText(Role? role) {
    switch (role) {
      case Role.thinker:
        return '想想';
      case Role.honest:
        return '老實人';
      case Role.bullshitter:
        return '瞎掰人';
      default:
        return '';
    }
  }
}
