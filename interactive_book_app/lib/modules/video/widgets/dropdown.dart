import 'package:flutter/material.dart';
import 'package:interactive_book_app/core/theme/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String>? items;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true, // ✅ الحل الأساسي - ياخد المساحة المتاحة بدل ما يفيض
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // قللت الحجم من 20 لـ 14
        filled: true,
        fillColor: AppColors.lightColor,
        hoverColor: Colors.red,
        hintText: hint,
        isDense: true, // ✅ يقلل الارتفاع الداخلي
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ), // ✅ padding أصغر بدل الافتراضي
      ),
      value: value,
      items: items?.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis, // ✅ يقص النص الطويل بدل ما يفيض
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}