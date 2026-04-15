import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';

class CustomBtn extends StatelessWidget {
  String text;
  Function() onTap;
  bool isLoading;
  bool isExpanded;
  CustomBtn(
      {
      required this.onTap,
      required this.text,
      this.isLoading = false,
      this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 50,
      padding: const EdgeInsets.all(16),
      onPressed: onTap,
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedCrossFade(
          firstChild: isExpanded
              ? Center(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 24),
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(fontSize: 24),
                ),
          secondChild: const SizedBox(
            width: 60,
            height: 26,
            child: CupertinoActivityIndicator(
              color: CupertinoColors.white,
            ),
          ),
          crossFadeState:
              isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200)),
    );
  }
}
