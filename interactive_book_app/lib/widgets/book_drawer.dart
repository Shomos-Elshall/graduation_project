import 'package:flutter/material.dart';
import 'package:interactive_book_app/models/book_model.dart';
import 'package:interactive_book_app/models/toc_model.dart';

class BookDrawer extends StatelessWidget {
  final BookModel book;
  final Function(TocModel) onChapterSelected;

  const BookDrawer({
    super.key,
    required this.book,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8F9FE), // لون خلفية هادئ ومريح
      child: Column(
        children: [
          // Header مطور بتصميم عصري
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              itemCount: book.toc.length,
              itemBuilder:
                  (context, index) =>
                      _buildTocEntry(context, book.toc[index], 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      // أزلنا الارتفاع الثابت height: 200
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1D0E53), Color(0xFF3B1E91)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false, // لا نريد مساحة أمان من الأسفل ليبقى التصميم متصلاً
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            30,
            20,
            30,
          ), // زيادة الـ padding ليعطي شكل الـ Header
          child: Column(
            mainAxisSize: MainAxisSize.min, // لجعل العمود يأخذ أقل مساحة ممكنة
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: Colors.white70,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                book.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19, // تقليل الخط قليلاً لضمان التناسق
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTocEntry(BuildContext context, TocModel item, int depth) {
    final bool isParent = item.children.isNotEmpty;

    if (isParent) {
      return Theme(
        // لتعديل شكل الـ ExpansionTile وإزالة الخطوط الفاصلة
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          iconColor: const Color(0xFF1D0E53),
          collapsedIconColor: Colors.grey,
          shape: const Border(), // إزالة الحدود عند الفتح
          collapsedShape: const Border(),
          leading: Icon(
            depth == 0 ? Icons.grid_view_rounded : Icons.folder_open_rounded,
            color: const Color(0xFF1D0E53),
            size: 22,
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: depth == 0 ? FontWeight.bold : FontWeight.w600,
              fontSize: 18,
              color: const Color(0xFF2D2D2D),
            ),
          ),
          children:
              item.children
                  .map((child) => _buildTocEntry(context, child, depth + 1))
                  .toList(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 16.0 + (depth * 12), right: 16),
        visualDensity: VisualDensity.compact,
        // شكل العنصر عند الضغط عليه
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: _buildLeadingIcon(depth),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87.withOpacity(0.8),
          ),
        ),
        onTap: () => onChapterSelected(item),
        hoverColor: const Color(0xFF1D0E53).withOpacity(0.05),
      ),
    );
  }

  Widget _buildLeadingIcon(int depth) {
    if (depth > 0) {
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1D0E53), width: 2),
          shape: BoxShape.circle,
        ),
      );
    }
    return const Icon(
      Icons.bookmark_border_rounded,
      size: 20,
      color: Color(0xFF1D0E53),
    );
  }
}
