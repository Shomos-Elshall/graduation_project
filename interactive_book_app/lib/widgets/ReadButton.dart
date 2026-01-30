import 'package:flutter/material.dart';
import 'package:interactive_book_app/screens/Home_Page.dart';

class ReadButton extends StatelessWidget {
  final String? selectedBook;
  const ReadButton({super.key, required this.selectedBook});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 160,
        margin: EdgeInsets.symmetric(vertical: 18),
        child: ElevatedButton(
          onPressed: () {
            if (selectedBook != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const HomePage();
                  },
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1D4A85),
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              "Read",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
