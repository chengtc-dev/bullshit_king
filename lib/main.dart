import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'data/topics_data.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 只有在「不是 Web」的情況下才初始化廣告
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }
  await TopicsData.loadTopics();
  runApp(const BullshitKingApp());
}

class BullshitKingApp extends StatelessWidget {
  const BullshitKingApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => GameProvider())],
    child: MaterialApp(
      title: 'Bullshit King',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
