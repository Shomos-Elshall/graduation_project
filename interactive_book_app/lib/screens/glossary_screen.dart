import 'package:flutter/material.dart';
import 'package:interactive_book_app/models/glossary_model.dart';

class GlossaryScreen extends StatelessWidget {
  final List<GlossaryModel> glossaryList; // القائمة اللي جاية من الموديل

  const GlossaryScreen({super.key, required this.glossaryList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Glossary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 24),
        backgroundColor: Color(0xFF1A0054), // لون غامق زي اللي في الصورة
      ),
      body: ListView.separated(
        itemCount: glossaryList.length,
        separatorBuilder:
            (context, index) => const Divider(
              height: 1,
              thickness: 0.4,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
        itemBuilder: (context, index) {
          final item = glossaryList[index];

          return Theme(
            // الجزء ده عشان نشيل الخطوط اللي بتظهر فوق وتحت الـ ExpansionTile لما بيتفتح
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                item.word,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF1A0054),
                ),
              ),
              // السهم (trailing) بيتضاف تلقائياً في الـ ExpansionTile
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.defination,
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        height:
                            1.5, // لزيادة المسافة بين السطور وجعلها مريحة للعين
                      ),
                    ),
                  ),
                ),
                // Divider(thickness: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
