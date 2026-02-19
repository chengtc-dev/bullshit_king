/// 題目模型類
///
/// 包含題目詞彙及其正確解釋
class Topic {
  /// 題目詞彙 (例如：量子糾纏)
  final String term;

  /// 正確解釋
  final String definition;

  /// 題目分類 (例如：物理學、心理學)
  final String category;

  /// 建構子
  const Topic({
    required this.term,
    required this.definition,
    this.category = '未分類',
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    term: json['term'] as String,
    definition: json['definition'] as String,
    category: json['category'] as String? ?? '未分類',
  );
}
