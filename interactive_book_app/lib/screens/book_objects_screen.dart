import 'package:flutter/material.dart';
import 'package:interactive_book_app/models/book_objects_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ObjectScreen extends StatelessWidget {
  final List<BookObjects> objectList;
  const ObjectScreen({super.key, required this.objectList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Learning Objects',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
        backgroundColor: const Color(0xFF1A0054),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: objectList.length,
        itemBuilder: (context, index) {
          final item = objectList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xffF5F7FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Numbered circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A0054),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF1A0054),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            // 1. بناء الرابط الأساسي
                            String finalUrl = item.url;
                            if (!finalUrl.startsWith('http')) {
                              finalUrl =
                                  'https://scube-applications-media54cbabfc-u3d19945rbtv.s3.amazonaws.com/$finalUrl';
                            }

                            // 2. إذا كان الملف PDF، نمرره عبر مشغل جوجل لضمان فتحه
                            if (finalUrl.toLowerCase().endsWith('.pdf')) {
                              finalUrl =
                                  'https://docs.google.com/viewer?embedded=true&url=$finalUrl';
                            }

                            // 3. الانتقال لشاشة الـ WebView
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ObjectWebViewScreen(
                                      title: item.title,
                                      url: finalUrl,
                                    ),
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.touch_app_outlined,
                                color: Color(0xFF1A0054),
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Click to practice',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 163, 161, 161),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ======= WebView Screen (تستخدم لعرض الروابط والـ PDF) =======
class ObjectWebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const ObjectWebViewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<ObjectWebViewScreen> createState() => _ObjectWebViewScreenState();
}

class _ObjectWebViewScreenState extends State<ObjectWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(
            JavaScriptMode.unrestricted,
          ) // ضروري جداً لمشغل جوجل
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) => setState(() => _isLoading = true),
              onPageFinished: (_) => setState(() => _isLoading = false),
              onWebResourceError: (error) {
                debugPrint("WebView Error: ${error.description}");
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A0054),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF1A0054)),
              ),
          ],
        ),
      ),
    );
  }
}
