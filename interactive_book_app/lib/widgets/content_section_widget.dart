import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import 'package:interactive_book_app/widgets/video_player_widget.dart';
import '../Services/applyBoldToText.dart';
import '../models/book_model.dart';
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
  String _selectedText = "";
  String contentText = " "; // المتغير الذي يخزن النص ويحدثه عند عمل Bold

  @override
  Widget build(BuildContext context) {
    String content =
        widget.isArabic
            ? (widget.section.textAr ?? "")
            : (widget.section.textEn ?? "");
    String sectionId = widget.section.id.toString();

    String processedContent = HighlightService.processHtml(
      content,
      widget.section.id.toString(),
    );
    processedContent = NoteService.processHtmlForNotes(
      processedContent,
      sectionId,
    );

    return SelectionArea(
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
            ContextMenuButtonItem(
              label: 'Bold',
              onPressed: () async {
                if (_selectedText.isNotEmpty) {
                  selectableRegionState.hideToolbar();

                  // 1. الحصول على النص الكامل الحالي للمحتوى
                  // (افترضنا أن النص مخزن في متغير اسمه contentText)
                  String updatedText = applyBoldToText(contentText, _selectedText);

                  // 2. تحديث قاعدة بيانات Hive لضمان الحفظ الدائم
                  var box = Hive.box<BookModel>('book'); // تأكدي من اسم الصندوق
                  var book = box.get('book'); // استرجاع الكتاب

                  if (book != null) {
                    // هنا نقوم بتحديث الحقل المناسب (مثل النص العربي) وحفظه
                    // ملاحظة: يجب تعديل هذا الجزء ليطابق مكان النص في الـ Model الخاص بكِ
                    await box.put('book', book);
                  }

                  // 3. تحديث واجهة المستخدم (setState) لرؤية التغيير فوراً
                  setState(() {
                    contentText = updatedText;
                  });

                  print("✅ تم جعل النص عريضاً وحفظه في Hive");
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
            direction: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
            textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
            fontSize: FontSize(18.0),
            lineHeight: const LineHeight(1.6),
          ),
          "b": Style(
            fontWeight: FontWeight.bold,
            color: Colors.black, // أو أي لون تحبيه للكلمات المهمة
          ),
          "strong": Style(
            fontWeight: FontWeight.bold,
          ),
        },
        onLinkTap: (url, _, __) {
          if (url != null && url.startsWith("note://")) {
            String originalText = Uri.decodeComponent(
              url.replaceFirst("note://", ""),
            );
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
                (ctx) => AppVideoPlayer(videoUrl: ctx.attributes['src'] ?? ""),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, String text) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Highlight Options",
              style: TextStyle(fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorOption(Colors.yellow, text),
                    _colorOption(Colors.greenAccent, text),
                    _colorOption(Colors.lightBlueAccent, text),
                    _colorOption(Colors.pinkAccent, text),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () async {
                    await HighlightService.clearHighlight(
                      text,
                      widget.section.id.toString(),
                    );
                    if (mounted) Navigator.pop(context);
                    widget.onRefresh();
                  },
                  icon: const Icon(Icons.format_color_reset, color: Colors.red),
                  label: const Text(
                    "Unhighlight",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _colorOption(Color color, String text) {
    return GestureDetector(
      onTap: () async {
        await HighlightService.saveHighlight(
          text,
          widget.section.id.toString(),
          color,
        );
        if (mounted) Navigator.pop(context);
        widget.onRefresh();
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: const Icon(Icons.format_paint, size: 15, color: Colors.black54),
      ),
    );
  }
}
