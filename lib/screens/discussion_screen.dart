import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ad_banner_widget.dart';
import 'voting_screen.dart';

/// 討論畫面
///
/// 顯示題目並計時，讓玩家進行辯論
class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Theme.of(context).colorScheme.surface, AppTheme.deepBlue],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text('討論時間', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            // 題目顯示
            Consumer<GameProvider>(
              builder: (context, game, child) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                ),
                child: Text(
                  game.currentTopic?.term ?? '題目',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 48,
                    shadows: [], // 移除陰影以保持清晰
                  ),
                ),
              ).animate().shimmer(duration: 2000.ms),
            ),
            const SizedBox(height: 40),
            // 獨立的計時器 Widget
            const _GameTimer(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                '請大家輪流解釋這個詞的意思。\n想想請仔細聆聽並找出破綻！',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Spacer(),
            // 開始投票按鈕
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: Consumer<GameProvider>(
                  builder: (context, game, child) => ElevatedButton.icon(
                    onPressed: () {
                      game.startVoting();
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const VotingScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.gavel),
                    label: const Text('開始投票'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const AdBannerWidget(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}

/// 獨立的計時器 Widget
///
/// 僅負責更新時間顯示，避免觸發整個畫面的重繪
class _GameTimer extends StatefulWidget {
  const _GameTimer();

  @override
  State<_GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<_GameTimer> {
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final minutes = (_seconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) => Text(
    _timerText,
    style: const TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.w200,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );
}
