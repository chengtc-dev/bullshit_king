import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'setup_screen.dart';

/// 主畫面
///
/// 顯示遊戲標題、開始按鈕和規則說明
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 背景漸層
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E004F), // 深紫色
              Color(0xFF000000), // 黑色
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // 標題
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '幹話王',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 72,
                        color: const Color(0xFFFFD700),
                        shadows: [
                          const Shadow(
                            blurRadius: 20,
                            color: Color(0x88FFD700),
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Image.asset(
                      'assets/icon/logo.png',
                      height: 72,
                    )
                  ],
                ).animate().fadeIn(duration: 800.ms).scale(delay: 200.ms),
                // 副標題
                Text(
                  'BULLSHIT KING',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    letterSpacing: 8,
                    color: Colors.white54,
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
                const Spacer(),
                // 開始遊戲按鈕
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SetupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('開始遊戲'),
                ).animate().fadeIn(delay: 1000.ms).shimmer(delay: 2000.ms, duration: 1500.ms),
                const SizedBox(height: 20),
                // 規則按鈕
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const RulesDialog(),
                    );
                  },
                  child: const Text('遊戲規則'),
                ).animate().fadeIn(delay: 1200.ms),
                const Spacer(),
                const Text('題目由生成式AI產生，可能會出錯').animate().fadeIn(delay: 1500.ms),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 規則彈窗
class RulesDialog extends StatelessWidget {
  const RulesDialog({super.key});

  Widget _buildRulePoint(BuildContext context, String title, List<String> descriptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...descriptions.map((text) => Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A0B2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFFFD700).withValues(alpha: 0.5)),
      ),
      title: Center(
        child: Text(
          '遊戲規則',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRulePoint(context, '1. 角色分配：', [
              '• 老實人：知道題目與正確解釋。',
              '• 瞎掰人：知道題目，需瞎掰解釋。',
              '• 想想：負責猜誰是老實人。',
            ]),
            const SizedBox(height: 16),
            _buildRulePoint(context, '2. 流程：', [
              '• 輪流查看身份（傳遞手機）。',
              '• 所有人輪流解釋題目（老實人說真話，瞎掰人說謊）。',
              '• 想想提問並投票。',
            ]),
            const SizedBox(height: 16),
            _buildRulePoint(context, '3. 計分：', [
              '• 猜對：想想與老實人得分。',
              '• 猜錯：被選中的瞎掰人得分。',
            ]),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFFD700),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('懂了'),
        ),
      ],
    );
  }
}
