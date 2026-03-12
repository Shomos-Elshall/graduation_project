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
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1D0E53)),
            child: Center(
              child: Text(
                book.title,
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
              itemCount: book.toc.length,
              itemBuilder:
                  (context, index) => _buildTocEntry(context, book.toc[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTocEntry(BuildContext context, TocModel item) {
    if (item.children.isNotEmpty) {
      return ExpansionTile(
        leading: const Icon(Icons.book, color: Color(0xFF1D0E53)),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children:
            item.children
                .map((child) => _buildTocEntry(context, child))
                .toList(),
      );
    }
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32, right: 16),
      leading: const Icon(Icons.label_important_outline, size: 20),
      title: Text(item.name),
      onTap: () => onChapterSelected(item),
    );
  }
}
