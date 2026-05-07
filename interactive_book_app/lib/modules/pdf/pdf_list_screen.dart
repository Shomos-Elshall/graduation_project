import 'package:flutter/material.dart';
import 'package:interactive_book_app/modules/pdf/pdfprovider.dart';
import 'package:interactive_book_app/modules/video/videosurvices/pdfview.dart';
import 'package:interactive_book_app/modules/pdf/pdfviewmodel.dart';

import 'package:provider/provider.dart';

class PdfListScreen extends StatefulWidget {
  const PdfListScreen({super.key});

  @override
  State<PdfListScreen> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<String> _titles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTitles();
  }

  Future<void> _loadTitles() async {
    final titles = await PdfViewModel.getAllTitles();
    setState(() {
      _titles = titles;
      _loading = false;
    });
  }

  void _onTitleSelected(String? title) {
    if (title == null) return;

    final pdfProvider = PdfProvider();
    pdfProvider.setSelectedTitle(title);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider<PdfProvider>(
              create: (_) => pdfProvider,
              child: const PdfView(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("choose your pdf")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                  hint: const Text('اختر عنوان'),
                  isExpanded: true,
                  items:
                      _titles
                          .map(
                            (title) => DropdownMenuItem(
                              value: title,
                              child: Text(title),
                            ),
                          )
                          .toList(),
                  onChanged: _onTitleSelected,
                ),
      ),
    );
  }
}
