import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../models/topic.dart';
import '../data/topics_data.dart';
import 'reveal_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // 過濾出該分類的所有題目
    List<Topic> topics;
    if (category == '全部') {
      topics = TopicsData.topics;
    } else {
      topics = TopicsData.topics.where((t) => t.category == category).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              const Color(0xFF1A237E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 隨機播放按鈕
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<GameProvider>().startGame(
                        category: category,
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RevealScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.shuffle),
                    label: const Text('隨機選題', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ).animate().fadeIn().slideY(),

              // 題目列表 header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      '或選擇特定題目 (${topics.length})',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const Expanded(
                      child: Divider(indent: 10, color: Colors.white24),
                    ),
                  ],
                ),
              ),

              // 題目列表
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return Card(
                      color: Colors.white.withValues(alpha: 0.1),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          topic.term,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.play_arrow_rounded),
                        onTap: () {
                          // 開始特定題目的遊戲
                          context.read<GameProvider>().startGame(
                            specificTopic: topic,
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RevealScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: (50 * index).ms).slideX();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
