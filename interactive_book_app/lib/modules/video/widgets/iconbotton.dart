import 'package:flutter/material.dart';
import 'package:interactive_book_app/core/theme/app_colors.dart';

class VideoControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double? size;

  const VideoControlButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.lightColor, size: size),
      onPressed: onPressed,
    );
  }
}
