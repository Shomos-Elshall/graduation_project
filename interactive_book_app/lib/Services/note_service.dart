import 'package:hive/hive.dart';

class NoteService {
  static const String boxName = 'notes_box';

  static Future<void> addNote(String sectionId, String originalText, String noteContent) async {
    var box = Hive.box(boxName);
    List<dynamic> notes = box.get(sectionId, defaultValue: []);
    // التأكد إن الملاحظة لنفس النص مش مكررة، لو مكررة نحدثها
    notes.removeWhere((note) => note['originalText'] == originalText);
    notes.add({
      'originalText': originalText, 
      'noteContent': noteContent,
    });
    await box.put(sectionId, notes);
  }

  static List<dynamic> getNotes(String sectionId) {
    var box = Hive.box(boxName);
    return box.get(sectionId, defaultValue: []);
  }

  static Future<void> deleteNote(String sectionId, String originalText) async {
    var box = Hive.box(boxName);
    List<dynamic> notes = box.get(sectionId, defaultValue: []);
    notes.removeWhere((note) => note['originalText'] == originalText);
    await box.put(sectionId, notes);
  }

  // دالة لإضافة أيقونة الملاحظات داخل الـ HTML
  static String processHtmlForNotes(String htmlData, String sectionId) {
    String modifiedHtml = htmlData;
    var notes = getNotes(sectionId);

    for (var note in notes) {
      String originalText = note['originalText'];
      modifiedHtml = modifiedHtml.replaceAll(
        originalText,
        '$originalText <a href="note://$originalText" style="text-decoration:none;"> 📝</a>',
      );
    }
    return modifiedHtml;
  }
}