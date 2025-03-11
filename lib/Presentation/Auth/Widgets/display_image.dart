import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Constants/app_strings.dart';
import 'package:admin_curator/Constants/app_styles.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(AppStrings.gop, fit: BoxFit.cover)),
        Positioned.fill(
          // ignore: deprecated_member_use
          child: Container(color: AppColors.primary.withOpacity(0.5)),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.welcomeTitle,
                style: AppStyles.title.copyWith(color: AppColors.white),
                textAlign: TextAlign.left,
              ),
              Text(
                AppStrings.welcomeSubtitle,
                style: AppStyles.subHeading.copyWith(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
