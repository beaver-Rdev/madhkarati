import 'package:flutter/material.dart';
import 'theme.dart';

/// مكان الشعار: استبدل assets/logo.png بشعارك (يظهر في الهيدر وشاشة البداية).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 36});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(size * .25),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * .25),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.image_outlined, size: size * .55, color: AppColors.muted),
          ),
        ),
      );
}
