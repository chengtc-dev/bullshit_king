# 瞎掰王 (Bullshit King)

一款適合 3-9 人的派對遊戲 App，考驗你的瞎掰與推理能力！

## 📖 遊戲介紹

「瞎掰王」是一款社交派對遊戲，玩家分為三種角色：
- **老實人**：知道題目與正確解釋
- **瞎掰人**：不知道題目，需要即興發揮
- **想想**：負責猜測誰是老實人

遊戲採用 Pass-and-Play 模式，玩家輪流傳遞手機查看自己的身份，然後輪流解釋題目詞彙。「想想」需要從所有解釋中找出誰是「老實人」、誰在瞎掰！

## ✨ 功能特色

- 🎭 **動態角色分配**：隨機分配想想、老實人、瞎掰人
- 📱 **Pass-and-Play 模式**：支援離線單機遊戲
- ⏱️ **討論計時器**：追蹤討論時間
- 🎨 **精美 UI**：深色派對風格主題，搭配流暢動畫
- 📊 **計分系統**：自動計算每局得分

## 🛠️ 技術棧

- **框架**: Flutter 3.35.6
- **語言**: Dart 3.9.2
- **狀態管理**: Provider
- **UI 動畫**: flutter_animate
- **字體**: Google Fonts (Outfit)

## 📦 安裝與運行

### 前置需求

- Flutter SDK >= 3.35.6
- Dart SDK >= 3.9.2

### 安裝步驟

```bash
# 克隆專案
git clone https://github.com/chengtc-dev/bullshit_king
cd bullshit_king

# 安裝依賴
flutter pub get

# 運行應用 (iOS Simulator)
flutter run

# 或建置 iOS 版本
flutter build ios --no-codesign --simulator
```

## ✅ 測試

本專案包含完整的單元測試和 Widget 測試，以確保核心邏輯的穩定性。

### 運行測試

要運行所有測試，請執行以下指令：

```bash
flutter test
```

### 測試覆蓋範圍

- **`game_provider_test.dart`**: 針對核心遊戲邏輯 (`GameProvider`) 的單元測試。
  - 玩家管理 (新增/移除)
  - 遊戲開始條件
  - 完整的遊戲流程 (角色分配、計分、重置)

## 📁 專案結構

```
lib/
├── data/
│   └── topics_data.dart        # 題目資料庫
├── models/
│   ├── player.dart             # 玩家模型
│   ├── topic.dart              # 題目模型
│   └── game_state.dart         # 遊戲階段枚舉
├── providers/
│   └── game_provider.dart      # 遊戲邏輯管理
├── screens/
│   ├── home_screen.dart        # 主畫面
│   ├── setup_screen.dart       # 玩家設定畫面
│   ├── reveal_screen.dart      # 身份揭示畫面
│   ├── discussion_screen.dart  # 討論畫面
│   ├── voting_screen.dart      # 投票畫面
│   └── result_screen.dart      # 結果畫面
├── theme/
│   └── app_theme.dart          # 應用程式主題
└── main.dart                   # 應用程式入口
test/
└── providers/
    └── game_provider_test.dart # 遊戲邏輯管理的單元測試
```

## 🎮 遊戲流程

1. **設定階段**：新增 3 位以上玩家
2. **揭示階段**：傳遞手機，每位玩家查看自己的身份
3. **討論階段**：所有人輪流解釋題目詞彙
4. **投票階段**：想想選擇誰是老實人
5. **結果階段**：揭曉答案與計分

## 📝 計分規則

- **想想猜對**：想想 +2 分，老實人 +2 分
- **想想猜錯**：被選中的瞎掰人 +2 分
