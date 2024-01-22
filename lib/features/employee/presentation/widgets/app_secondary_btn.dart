import 'package:flutter/material.dart';

import '../../../../resources/app_colors.dart';

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppColors.lightBlueColor, // Background Color
      ),
      child: Text(
        text,
      ),
    );
  }
}
