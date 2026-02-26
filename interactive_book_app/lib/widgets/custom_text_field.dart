import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.onChanged,
  });
  final String hintText;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black, fontSize: 18),
          prefixIcon: const Icon(Icons.search),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff1C0054)),
            borderRadius: BorderRadius.circular(16),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1C0054)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
