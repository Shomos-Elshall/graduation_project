import 'package:flutter/material.dart';
import 'package:interactive_book_app/widgets/app_bar.dart';

class Selectedbook extends StatefulWidget {
  const Selectedbook({super.key});

  @override
  State<Selectedbook> createState() => SelectedbookState();
}

class SelectedbookState extends State<Selectedbook> {
  String? selectedBook;
  List<String> books = ["Biology", "Chemistry", "Math"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
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
                  
                   border: InputBorder.none,),
                   

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
            ),
  





          ],
        ),
      ),
    );
  }
}
