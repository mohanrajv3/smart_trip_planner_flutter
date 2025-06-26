import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../glassmorphic_card.dart';

class AnimatedChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final VoidCallback? onCopy;

  const AnimatedChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: GlassmorphicCard(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isUser ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTimestamp(timestamp),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (isUser && onCopy != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onCopy,
                        child: const Icon(
                          Icons.copy,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          gradient: isUser
              ? AppColors.primaryGradient
              : LinearGradient(
            colors: [
              AppColors.surface.withOpacity(0.6),
              AppColors.surface.withOpacity(0.4),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(
      begin: isUser ? 0.3 : -0.3,
      duration: 400.ms,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}


