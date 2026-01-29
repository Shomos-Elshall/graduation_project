import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF1D4A85),
      leading: Padding(
        padding: EdgeInsets.all(8),
        child: Image(
          image: AssetImage("assets/images/image 1 (1).png"),
          height: 60,
          width: 60,
          fit: BoxFit.contain,
          
        ),
      ),
    );
  }
  @override
Size get preferredSize => Size.fromHeight(kToolbarHeight);

}
