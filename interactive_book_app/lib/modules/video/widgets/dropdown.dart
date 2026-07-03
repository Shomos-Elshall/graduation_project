
import 'package:flutter/material.dart';
import 'package:interactive_book_app/core/theme/app_colors.dart';



class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String>? items;
  final Function(String?) onChanged;

  const CustomDropdown({super.key, 
    required this.hint,
    this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        filled: true,
        fillColor: AppColors.lightColor,
        hoverColor: Colors.red,

        hintText: hint,
        // labelText: hint,
        // border: OutlineInputBorder(
        //
        //   borderRadius: BorderRadius.circular(25),
        //   borderSide: BorderSide(color: Colors.yellow)
        // ),
      ),
      value: value,
      items:
          items?.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
    );
  }
}

