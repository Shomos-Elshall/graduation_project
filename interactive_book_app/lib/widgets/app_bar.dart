import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0XFF1D4A85),
       leading: Padding(padding: EdgeInsets.all(8),
       child: Image(image:AssetImage("interactive_book_app/assets/images/image 1.png")),
       
       ),
    );
  }
}
