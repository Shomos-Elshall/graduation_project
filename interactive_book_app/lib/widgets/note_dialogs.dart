import 'package:flutter/material.dart';
import '../services/note_service.dart';

class NoteDialogs {
  // 1. Add Note Dialog
  static void showAddNoteDialog({
    required BuildContext context,
    required String sectionId,
    required String selectedText,
    required VoidCallback onRefresh,
  }) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Add Note"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Type your note here...",
              ),
              autofocus: true,
              maxLines: 3,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Color(0xff1C0054)),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1C0054),
                ),
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    await NoteService.addNote(
                      sectionId,
                      selectedText,
                      controller.text,
                    );
                    Navigator.pop(context);
                    onRefresh();
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  // 2. View Saved Note Dialog
  static void showSavedNoteDialog({
    required BuildContext context,
    required String originalText,
    required String savedNote,
    required String sectionId,
    required VoidCallback onRefresh,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("My Note", style: TextStyle(fontSize: 24)),
            content: Text(savedNote),
            actions: [
              // Delete Button
              TextButton(
                onPressed: () async {
                  await NoteService.deleteNote(sectionId, originalText);
                  Navigator.pop(context);
                  onRefresh();
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              // Edit Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close View Dialog
                  showEditNoteDialog(
                    context: context,
                    sectionId: sectionId,
                    originalText: originalText,
                    currentNote: savedNote,
                    onRefresh: onRefresh,
                  );
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
    );
  }

  // 3. Edit Existing Note Dialog
  static void showEditNoteDialog({
    required BuildContext context,
    required String sectionId,
    required String originalText,
    required String currentNote,
    required VoidCallback onRefresh,
  }) {
    TextEditingController controller = TextEditingController(text: currentNote);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Edit Note"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(),
              autofocus: true,
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    await NoteService.addNote(
                      sectionId,
                      originalText,
                      controller.text,
                    );
                    Navigator.pop(context);
                    onRefresh();
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }
}
