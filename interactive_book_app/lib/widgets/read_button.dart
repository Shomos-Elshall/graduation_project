/*import 'package:flutter/material.dart';
import 'package:interactive_book_app/screens/Home_Page.dart';

class ReadButton extends StatelessWidget {
  final String? selectedBook;
  const ReadButton({super.key, required this.selectedBook});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        maximumSize: Size(180, 70),
        backgroundColor: Color(0xFF1D4A85),
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Center(
        child: Text(
          "Read",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
*/
