import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

/// 投票畫面
///
/// 讓「想想」選擇誰是「老實人」
class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  Player? _selectedPlayer;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Consumer<GameProvider>(
      builder: (context, game, child) {
        final thinker = game.thinker;
        // 候選人列表：除了想想以外的所有人
        final candidates = game.players
            .where((p) => p.id != thinker?.id)
            .toList();

        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text('想想請投票', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text('誰是老實人？', style: Theme.of(context).textTheme.bodyLarge),
              // 候選人網格
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    final player = candidates[index];
                    final isSelected = _selectedPlayer?.id == player.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPlayer = player;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white24,
                              child: Text(
                                player.name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              player.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ).animate().scale(delay: (100 * index).ms);
                  },
                ),
              ),
              // 確認選擇按鈕
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedPlayer != null
                        ? () {
                            game.submitVote(_selectedPlayer!);
                            Navigator.pushReplacement<void, void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const ResultScreen(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('確認選擇'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
