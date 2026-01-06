import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/topics_data.dart';
import '../theme/app_theme.dart';
import 'category_detail_screen.dart';

class TopicSelectionScreen extends StatelessWidget {
  const TopicSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 取得所有唯一分類
    final Set<String> categories = TopicsData.topics
        .map((t) => t.category)
        .toSet();
    final List<String> sortedCategories = [
      '全部',
      ...categories.toList()..sort(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('選擇題目類別'),
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
              AppTheme.deepBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              final category = sortedCategories[index];
              return _buildCategoryCard(context, category, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category, int index) =>
      GestureDetector(
            onTap: () {
              // 導向分類詳情畫面
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) =>
                      CategoryDetailScreen(category: category),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          )
          .animate()
          .fadeIn(delay: (index * 50).ms)
          .scale(duration: 300.ms, curve: Curves.easeOutBack);
}
