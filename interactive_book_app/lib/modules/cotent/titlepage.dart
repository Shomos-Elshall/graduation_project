import 'package:flutter/material.dart';
import 'package:interactive_book_app/modules/video/videosurvices/videoprovider.dart';

import 'package:provider/provider.dart';

import '../video/models/Videoresponse.dart';
import '../video/videoveiw.dart';
import 'content choice.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF1D0E53),
        title: const Text(
          'Learning Objects',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
      ),
      body: FutureBuilder<List<String>>(
        future: ContentChoice.getAllTitles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Courses Found"));
          }

          final titles = snapshot.data!;

          return Container(
            color: const Color(0xfff3f3f3),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.bookmark),
                    ),
                    title: Text(
                      titles[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // subtitle: const Text("Course content"),
                    // trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      try {
                        final title = titles[index];

                        var result = await ContentChoice.openContentByTitle(
                          title,
                        );

                        if (!context.mounted) return;

                        context.read<VideoProvider>().setSelectedTitle(title);

                        if (result is Videoresponse) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Videoveiw(),
                            ),
                          );
                        }
                      } catch (e) {
                        print("onTap error: $e"); // ← هنا هتشوفي المشكلة
                      }
                    },
                    //   onTap: () async {
                    //
                    //     var result = await ContentChoice.openContentByTitle(titles[index]);
                    //     if (!context.mounted) return;
                    //     context.read<VideoProvider>().setSelectedTitle(titles[index]);
                    //
                    //     if (result is Pdfresponse) {
                    //       // Navigator.push(
                    //       //   context,
                    //       //   // MaterialPageRoute(
                    //       //   //   // builder: (_) => PdfViewScreen(pdf: result),
                    //       //   // ),
                    //       // );
                    //     }
                    //
                    //     if (result is Videoresponse) {
                    //
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (_) => Videoveiw(),
                    //         ),
                    //       );
                    //     }
                    //   }
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
