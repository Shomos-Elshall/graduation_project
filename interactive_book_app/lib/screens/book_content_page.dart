import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:interactive_book_app/models/book_model.dart';
import 'package:interactive_book_app/models/toc_model.dart';
import 'package:interactive_book_app/models/content_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:interactive_book_app/screens/glossary_screen.dart';
import 'package:interactive_book_app/widgets/video_player_widget.dart';

import '../Services/bookmark_service.dart';
import 'bookmarks_screen.dart';

class BookContentPage extends StatefulWidget {
  final BookModel book;
  final TocModel currentChapter;

  const BookContentPage({
    super.key,
    required this.book,
    required this.currentChapter,
  });

  @override
  State<BookContentPage> createState() => _BookContentPageState();
}

class _BookContentPageState extends State<BookContentPage> {
  bool isArabic = false; // افتراضياً بيعرض إنجليزي
  TocModel? currentChapter;
  String? _currentSelectedText;
  // هنغير ده ليكون List عشان لو الشابتر جواه كذا Section يعرضهم كلهم
  List<ContentModel> displaySections = [];

  @override
  void initState() {
    super.initState();
    if (widget.currentChapter != null) {
      _loadContent(widget.currentChapter);
    } else if (widget.book.toc.isNotEmpty) {
      // ده احتياطي لو لسبب ما الشابتر المرسل كان null
      _loadContent(widget.book.toc[0]);
    }
  }

  void _loadContent(TocModel chapter) {
    setState(() {
      currentChapter = chapter;

      // الحل هنا: بنبحث عن السكشن اللي الـ ID بتاعه مطابق للـ ID بتاع الشابتر المختار فقط
      // ده هيضمن إن لو ضغطت على الشابتر الكبير يعرض الـ Intro بتاعته بس
      // ولو ضغطت من الـ Drawer على سكشن فرعي، يعرض السكشن ده بس
      displaySections =
          widget.book.contents.where((content) {
            return content.id == chapter.id;
          }).toList();

      // خطوة احتياطية: لو السكشن المختار ملوش محتوى مباشر، ممكن تظهري أول ابن له
      if (displaySections.isEmpty && chapter.children.isNotEmpty) {
        final firstChildId = chapter.children[0].id;
        displaySections =
            widget.book.contents.where((content) {
              return content.id == firstChildId;
            }).toList();
      }
    });
  }

  String _processHtmlContent(String originalHtml, dynamic section) {
    var box = Hive.box('highlights');
    String sectionKey = "section_${section.id}";
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

        // تحويل رقم اللون إلى Hex ليفهمه الـ HTML
        String hexColor =
            '#${int.parse(colorValue).toRadixString(16).substring(2)}';

        // استبدال الكلمة بـ span ملون
        modifiedHtml = modifiedHtml.replaceAll(
          word,
          '<span style="background-color: $hexColor; border-radius: 4px; padding: 0 2px;">$word</span>',
        );
      }
    }
    return modifiedHtml;
  }

  // دالة الحفظ مع اللون
  void _saveHighlightToHive(
    String text,
    dynamic section,
    Color selectedColor,
  ) async {
    var box = Hive.box('highlights');
    String sectionKey = "section_${section.id}";
    List<String> currentHighlights = List<String>.from(
      box.get(sectionKey, defaultValue: []),
    );

    // نمسح أي تظليل قديم لنفس الكلمة قبل إضافة اللون الجديد (عشان ميحصلش تكرار)
    currentHighlights.removeWhere(
      (entry) => entry.startsWith("${text.trim()}|"),
    );

    // إضافة الكلمة مع كود اللون الجديد
    currentHighlights.add("${text.trim()}|${selectedColor.value}");

    await box.put(sectionKey, currentHighlights);
    setState(() {}); // تحديث الشاشة فوراً
  }

  // دالة إلغاء التظليل
  void _clearHighlight(String text, dynamic section) async {
    var box = Hive.box('highlights');
    String sectionKey = "section_${section.id}";
    List<String> currentHighlights = List<String>.from(
      box.get(sectionKey, defaultValue: []),
    );

    // حذف المدخل الذي يبدأ بهذه الكلمة
    currentHighlights.removeWhere(
      (entry) => entry.startsWith("${text.trim()}|"),
    );

    await box.put(sectionKey, currentHighlights);
    setState(() {}); // تحديث الشاشة لإخفاء اللون
  }

  void _showHighlightOptions(
    BuildContext context,
    String text,
    dynamic section,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Highlight Options", style: TextStyle(fontSize: 16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // صف الألوان
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorOption(context, text, section, Colors.yellow),
                    _colorOption(context, text, section, Colors.greenAccent),
                    _colorOption(
                      context,
                      text,
                      section,
                      Colors.lightBlueAccent,
                    ),
                    _colorOption(context, text, section, Colors.pinkAccent),
                  ],
                ),
                SizedBox(height: 20),
                // زر إلغاء التظليل
                TextButton.icon(
                  onPressed: () {
                    _clearHighlight(text, section);
                    Navigator.pop(context); // إغلاق الدايالوج
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

  // ويدجت مساعد لرسم الدوائر الملونة
  Widget _colorOption(
    BuildContext context,
    String text,
    dynamic section,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        _saveHighlightToHive(text, section, color);
        Navigator.pop(context); // إغلاق الدايالوج بعد الاختيار
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: Icon(Icons.format_paint, size: 15, color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                isArabic = !isArabic; // بيعكس اللغة لما تضغطي
              });
            },
            icon: const Icon(Icons.translate, color: Colors.white, size: 27),
            label: Text(
              isArabic ? "AR" : "EN",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 24),

          ValueListenableBuilder(
            valueListenable: Hive.box<TocModel>('bookmarks_box').listenable(),
            builder: (context, Box<TocModel> box, _) {
              final isMarked = box.containsKey(currentChapter?.id.toString());

              return IconButton(
                icon: Icon(
                  size: 27,
                  isMarked ? Icons.bookmark : Icons.bookmark_border,
                  color:
                      isMarked ? Colors.white : Colors.white, // ذهبي لو محفوظ
                ),
                onPressed: () {
                  // استدعاء خدمة الحفظ عند الضغط
                  BookmarkService.toggleBookmark(currentChapter!);
                },
              );
            },
          ),
          SizedBox(width: 24),
          PopupMenuButton(
            iconSize: 32,
            color: Colors.white,
            menuPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            borderRadius: BorderRadius.circular(64),
            onSelected: (value) {
              if (value == 'Glossary') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => new GlossaryScreen(
                          glossaryList: widget.book.glossary,
                        ),
                  ),
                );
              } else if (value == "Bookmarks") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // تأكدي إنك بتبعتي الكتاب معاكي لو صفحة البوك مارك محتاجاه
                    builder: (context) => BookmarksScreen(book: widget.book),
                  ),
                );
              }
            },

            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "Glossary",
                  child: Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: Color(0xFF1A0054),
                        size: 29,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Glossary",
                        style: TextStyle(
                          color: Color(0xFF1A0054),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuItem<String>(
                  value: "Bookmarks",
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_outline,
                        color: Color(0xFF1A0054),
                        size: 29,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Bookmarks",
                        style: TextStyle(
                          color: Color(0xFF1A0054),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: "Objects",
                  child: Row(
                    children: [
                      Icon(
                        Icons.extension_outlined,
                        color: Color(0xFF1A0054),
                        size: 29,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Objects",
                        style: TextStyle(
                          color: Color(0xFF1A0054),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        elevation: 0,
        backgroundColor: const Color(0xFF1A0054),

        iconTheme: const IconThemeData(color: Colors.white, size: 35),
      ),
      drawer: _buildBookDrawer(context),
      body:
          currentChapter == null
              ? const Center(
                child: Text(
                  "Select a chapter",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentChapter!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D0E53),
                      ),
                    ),
                    const Divider(height: 30),

                    Expanded(
                      child:
                          displaySections.isEmpty
                              ? const Center(
                                child: Text(
                                  "No content found for this section",
                                ),
                              )
                              : ListView.builder(
                                itemCount: displaySections.length,
                                itemBuilder: (context, index) {
                                  final section = displaySections[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: SelectionArea(
                                      // هتخليني قادره احدد نص معين
                                      onSelectionChanged: (content) {
                                        _currentSelectedText =
                                            content?.plainText;
                                      },

                                      contextMenuBuilder: (
                                        context,
                                        selectableRegionState,
                                      ) {
                                        return AdaptiveTextSelectionToolbar.buttonItems(
                                          anchors:
                                              selectableRegionState
                                                  .contextMenuAnchors,
                                          buttonItems: [
                                            ...selectableRegionState
                                                .contextMenuButtonItems,
                                            ContextMenuButtonItem(
                                              label: 'Highlight',
                                              onPressed: () {
                                                if (_currentSelectedText !=
                                                        null &&
                                                    _currentSelectedText!
                                                        .isNotEmpty) {
                                                  // إخفاء القائمة الأصلية أولاً
                                                  selectableRegionState
                                                      .hideToolbar();
                                                  // فتح قائمة الألوان وإلغاء التظليل
                                                  _showHighlightOptions(
                                                    context,
                                                    _currentSelectedText!,
                                                    section,
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                      child: Html(
                                        data: _processHtmlContent(
                                          isArabic
                                              ? (section.textAr ?? "")
                                              : (section.textEn ?? ""),
                                          section,
                                        ),
                                        extensions: [
                                          // هذا هو الـ Custom Extension
                                          TagExtension(
                                            tagsToExtend: {"iframe"},
                                            builder: (extensionContext) {
                                              // استخراج الرابط من وسم الـ iframe
                                              final videoUrl =
                                                  extensionContext
                                                      .attributes['src'];
                                              if (videoUrl != null &&
                                                  videoUrl.isNotEmpty) {
                                                return AppVideoPlayer(
                                                  videoUrl: videoUrl,
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ],
                                        style: {
                                          "mark": Style(
                                            backgroundColor: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          "body": Style(
                                            direction:
                                                isArabic
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                            textAlign:
                                                isArabic
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                          ),
                                          "p": Style(
                                            fontSize: FontSize(18.0),
                                            textAlign: TextAlign.justify,
                                          ),
                                          "li": Style(fontSize: FontSize(16.0)),
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildBookDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1D0E53)),
            child: Center(
              child: Text(
                widget.book.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.book.toc.length,
              itemBuilder:
                  (context, index) => _buildTocEntry(widget.book.toc[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTocEntry(TocModel item) {
    if (item.children.isNotEmpty) {
      return ExpansionTile(
        leading: const Icon(Icons.book, color: Color(0xFF1D0E53)),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: item.children.map((child) => _buildTocEntry(child)).toList(),
      );
    } else {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 32, right: 16),
        leading: const Icon(Icons.label_important_outline, size: 20),
        title: Text(item.name),
        onTap: () {
          _loadContent(item);
          Navigator.pop(context);
        },
      );
    }
  }
}
