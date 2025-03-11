import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Constants/app_styles.dart';
import 'package:flutter/material.dart';

class GlobalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final double width;
  final double height;

  const GlobalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.width = 200,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : AppColors.primary,
          foregroundColor: isOutlined ? AppColors.primary : Colors.white,
          side: isOutlined ? const BorderSide(color: AppColors.primary) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppStyles.buttonText,
        ),
        child: Text(text),
      ),
    );
  }
}
