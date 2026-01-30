import 'package:flutter/material.dart';

class DropDownButton extends StatelessWidget {
  const DropDownButton({super.key});

  @override
  Widget build(BuildContext context) {
    String? selectedBook;
    List<String> books = ["Biology", "Chemistry", "Math"];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1D4A85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          dropdownColor: Colors.white,

          decoration: InputDecoration(
            labelText: "Book",
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),

            /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFF1D4A85))

                    // ),
                  ),
                  ),
                  */
            border: InputBorder.none,
          ),

          value: selectedBook,
          items:
              books
                  .map(
                    (book) => DropdownMenuItem<String>(
                      value: book,
                      child: Text(book),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              selectedBook = value;
            });
          },
          iconEnabledColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );
  }
}
