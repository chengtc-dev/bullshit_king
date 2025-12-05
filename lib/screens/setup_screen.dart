import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import 'reveal_screen.dart';

/// 設定畫面
/// 
/// 允許玩家輸入名稱並加入遊戲
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _nameController = TextEditingController();

  /// 新增玩家
  void _addPlayer() {
    if (_nameController.text.isNotEmpty) {
      context.read<GameProvider>().addPlayer(_nameController.text);
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('玩家設定'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<GameProvider>(
        builder: (context, game, child) {
          return Column(
            children: [
              // 輸入區塊
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: '輸入玩家名稱',
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _addPlayer(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: _addPlayer,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // 玩家列表
              Expanded(
                child: ListView.builder(
                  itemCount: game.players.length,
                  itemBuilder: (context, index) {
                    final player = game.players[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            player.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(player.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => game.removePlayer(player.id),
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideX();
                  },
                ),
              ),
              // 開始遊戲按鈕
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: game.canStartGame
                        ? () {
                            game.startGame();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const RevealScreen()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: game.canStartGame
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      game.canStartGame ? '開始遊戲' : '至少需要3位玩家',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
