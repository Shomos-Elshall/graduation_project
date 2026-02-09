import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({super.key,required this.hinttext,required this.onChanged});
  final String hinttext;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.black,fontSize: 14),
        prefixIcon: const Icon(Icons.search),
        fillColor: const Color(0xFF1D4A85),

        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF1D4A85)),

          
        ),
      ),
    );
  }
}
