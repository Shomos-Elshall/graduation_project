import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HighlightService {
  static const String boxName = 'highlights';

  /// معالجة نص الـ HTML وإضافة وسوم التظليل
  static String processHtml(String originalHtml, String sectionId) {
    var box = Hive.box(boxName);
    String sectionKey = "section_$sectionId";
    List<String> savedEntries = List<String>.from(
      box.get(sectionKey, defaultValue: []),
    );

    if (savedEntries.isEmpty) return originalHtml;

    String modifiedHtml = originalHtml;
    for (String entry in savedEntries) {
      if (entry.contains('|')) {
        var parts = entry.split('|');
        String word = parts[0];
        String colorValue = parts[1];
        String hexColor =
            '#${int.parse(colorValue).toRadixString(16).substring(2)}';

        modifiedHtml = modifiedHtml.replaceAll(
          word,
          '<span style="background-color: $hexColor; border-radius: 4px; padding: 0 2px;">$word</span>',
        );
      }
    }
    return modifiedHtml;
  }

  /// حفظ التظليل
  static Future<void> saveHighlight(
    String text,
    String sectionId,
    Color color,
  ) async {
    var box = Hive.box(boxName);
    String sectionKey = "section_$sectionId";
    List<String> highlights = List<String>.from(
      box.get(sectionKey, defaultValue: []),
    );

    highlights.removeWhere((e) => e.startsWith("${text.trim()}|"));
    highlights.add("${text.trim()}|${color.value}");
    await box.put(sectionKey, highlights);
  }

  /// مسح التظليل
  static Future<void> clearHighlight(String text, String sectionId) async {
    var box = Hive.box(boxName);
    String sectionKey = "section_$sectionId";
    List<String> highlights = List<String>.from(
      box.get(sectionKey, defaultValue: []),
    );

    highlights.removeWhere((e) => e.startsWith("${text.trim()}|"));
    await box.put(sectionKey, highlights);
  }
}
