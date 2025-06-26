import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    Key? key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: AppColors.surface.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  AppColors.surface.withOpacity(0.3),
                  AppColors.surface.withOpacity(0.6),
                  AppColors.surface.withOpacity(0.3),
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).shimmer(
            duration: 1200.ms,
            delay: 300.ms,
          ),
        ],
      ),
    );
  }
}

