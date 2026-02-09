import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  const DropDownButton({super.key});

  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  @override
  Widget build(BuildContext context) {
    String? selectedBook;
    List<String> books = ["Biology", "Chemistry", "Math"];
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1C4A85),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: (DropdownButton<String>(
        hint: Text(
          "Select a book",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 27,
          ),
        ),
        value: selectedBook,
        items:
            books.map((String book) {
              return DropdownMenuItem<String>(
                value: book,
                child: Text(
                  book,
                  style: TextStyle(
                    color: Color(0xff1C4A85),
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              );
            }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedBook = newValue;
          });
        },
        iconSize: 50,
        iconEnabledColor: Colors.white,
        isExpanded: true,
      )),
    );
  }
}
