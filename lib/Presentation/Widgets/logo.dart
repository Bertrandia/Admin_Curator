import 'package:admin_curator/Constants/app_strings.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double height;
  const LogoWidget({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppStrings.logo, height: height);
  }
}
