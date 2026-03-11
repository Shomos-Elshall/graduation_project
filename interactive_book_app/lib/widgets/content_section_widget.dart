import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:interactive_book_app/widgets/video_player_widget.dart';
import '../models/content_model.dart';
import '../services/highlight_service.dart';
import '../services/note_service.dart';  
import 'note_dialogs.dart';  

class ContentSectionWidget extends StatefulWidget {
  final ContentModel section;
  final bool isArabic;
  final VoidCallback onRefresh;

  const ContentSectionWidget({
    super.key,
    required this.section,
    required this.isArabic,
    required this.onRefresh,
  });

  @override
  State<ContentSectionWidget> createState() => _ContentSectionWidgetState();
}

class _ContentSectionWidgetState extends State<ContentSectionWidget> {
  // المتغير الذي سيحفظ النص المحدّد حالياً
  String _selectedText = "";

  @override
  Widget build(BuildContext context) {
    // تحديد النص بناءً على اللغة
    String content =
        widget.isArabic
            ? (widget.section.textAr ?? "")
            : (widget.section.textEn ?? "");
            String sectionId = widget.section.id.toString();


    // معالجة النص لإظهار التظليلات المحفوظة من Hive
    String processedContent = HighlightService.processHtml(
      content,
      widget.section.id.toString(),
    );
    // 2. ثم معالجة الملاحظات لإضافة الأيقونة 📝
    processedContent = NoteService.processHtmlForNotes(processedContent, sectionId);
    

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: SelectionArea(
        // تحديث النص المحدّد فوراً عند تغيير التحديد
        onSelectionChanged: (SelectedContent? content) {
          _selectedText = content?.plainText ?? "";
        },
        contextMenuBuilder: (context, selectableRegionState) {
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: selectableRegionState.contextMenuAnchors,
            buttonItems: [
              ...selectableRegionState.contextMenuButtonItems,
              ContextMenuButtonItem(
                label: 'Highlight',
                onPressed: () {
                  if (_selectedText.isNotEmpty) {
                    selectableRegionState.hideToolbar();
                    _showColorPicker(context, _selectedText);
                  }
                },
              ),
              // زر إضافة ملاحظة (Add Note) الجديد
              ContextMenuButtonItem(
                label: 'Add Note',
                onPressed: () {
                  if (_selectedText.isNotEmpty) {
                    selectableRegionState.hideToolbar();
                    NoteDialogs.showAddNoteDialog(
                      context: context,
                      sectionId: sectionId,
                      selectedText: _selectedText,
                      onRefresh: widget.onRefresh,
                    );
                  }
                },
              ),
            ],
          );
        },
        child: Html(
          data: processedContent,
          style: {
            "body": Style(
              direction:
                  widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
              textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
              fontSize: FontSize(18.0),
              lineHeight: const LineHeight(1.6),
            ),
          },
          // استدعاء دالة النقر على الأيقونة 📝
          onLinkTap: (url, _, __) {
            if (url != null && url.startsWith("note://")) {
              String originalText = Uri.decodeComponent(url.replaceFirst("note://", ""));
              var notes = NoteService.getNotes(sectionId);
              
              var currentNote = notes.firstWhere(
                (n) => n['originalText'] == originalText,
                orElse: () => null,
              );

              if (currentNote != null) {
                NoteDialogs.showSavedNoteDialog(
                  context: context,
                  originalText: originalText,
                  savedNote: currentNote['noteContent'],
                  sectionId: sectionId,
                  onRefresh: widget.onRefresh,
                );
              }
            }
          },
          
          extensions: [
            TagExtension(
              tagsToExtend: {"iframe"},
              builder:
                  (ctx) =>
                      AppVideoPlayer(videoUrl: ctx.attributes['src'] ?? ""),
            ),
  



          ],
        ),
      ),
    );
  }

  // نافذة اختيار الألوان ومسح التظليل
  void _showColorPicker(BuildContext context, String text) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Highlight Options", style: TextStyle(fontSize: 16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // صف الألوان
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorOption(Colors.yellow, text),
                    _colorOption(Colors.greenAccent, text),
                    _colorOption(Colors.lightBlueAccent, text),
                    _colorOption(Colors.pinkAccent, text),
                  ],
                ),
                SizedBox(height: 20),
                // زر إلغاء التظليل
                TextButton.icon(
                  onPressed: () async {
                    await HighlightService.clearHighlight(
                      text,
                      widget.section.id.toString(),
                    );
                    if (mounted) Navigator.pop(context);
                    widget.onRefresh(); // لتحديث الصفحة وإظهار النص بدون تظليل
                  },
                  icon: Icon(Icons.format_color_reset, color: Colors.red),
                  label: Text(
                    "Unhighlight",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // ويدجت صغير لاختيار اللون
  Widget _colorOption(Color color, String text) {
    return GestureDetector(
      onTap: () async {
        await HighlightService.saveHighlight(
          text,
          widget.section.id.toString(),
          color,
        );
        if (mounted) Navigator.pop(context);
        widget.onRefresh(); // لتحديث الواجهة وعرض اللون الجديد
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: const Icon(Icons.format_paint, size: 15, color: Colors.black54),
      ),
    );
  }
}
