class TextContent {
  final String en;

  TextContent({required this.en});

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(en: json['en'] as String);
  }
}
