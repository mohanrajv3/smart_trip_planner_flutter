import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/glassmorphic_card.dart';
import '../../widgets/common/animated_chat_bubble.dart';
import '../../providers/ai_chat_provider.dart';
import '../../providers/trip_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String tripId;

  const ChatScreen({
    Key? key,
    required this.tripId,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatProvider.notifier).loadChatHistory(widget.tripId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);
    final trip = ref.watch(tripsProvider).trips.firstWhere(
          (t) => t.id == widget.tripId,
      orElse: () => Trip(
        id: '',
        title: '',
        startDate: '',
        endDate: '',
        days: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onTap: () => context.go('/itinerary/${widget.tripId}'),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip.title.isNotEmpty ? trip.title : 'Trip Assistant',
              style: AppTextStyles.h4,
            ),
            if (chatState.isLoading)
              Text(
                'Thinking...',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondary,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onTap: _clearChat,
            icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error),
          ).animate().scale(duration: 400.ms),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
              child: chatState.messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (chatState.isLoading && index == chatState.messages.length) {
                    return GlassmorphicCard(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.secondary,
                              child: const Icon(
                                Icons.smart_toy_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Thinking...',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms);
                  }
                  final message = chatState.messages[index];
                  return AnimatedChatBubble(
                    message: message.content,
                    isUser: message.isUser,
                    timestamp: message.timestamp,
                    onCopy: () {
                      // Implement copy functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Message copied to clipboard'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ).animate().slideY(
                    begin: 0.3,
                    duration: 400.ms,
                    delay: Duration(milliseconds: index * 50),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _messageController,
                    hint: 'Ask something about your trip...',
                    maxLines: 3,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: '',
                  icon: Icon(
                    chatState.isLoading
                        ? Icons.hourglass_empty
                        : Icons.send_outlined,
                    color: Colors.white,
                  ),
                  onPressed: chatState.isLoading ? null : _sendMessage,
                  variant: ButtonVariant.secondary,
                  size: ButtonSize.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: GlassmorphicCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Start Planning',
              style: AppTextStyles.h4,
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me anything to refine your trip!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSuggestion('Add more activities'),
                _buildSuggestion('Find restaurants'),
                _buildSuggestion('Check weather'),
                _buildSuggestion('Get local tips'),
              ],
            ),
          ],
        ),
      ).animate().scale(duration: 600.ms),
    );
  }

  Widget _buildSuggestion(String text) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    await ref.read(aiChatProvider.notifier).sendMessage(
      message,
      tripId: widget.tripId,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Clear Chat?',
          style: AppTextStyles.h4,
        ),
        content: Text(
          'This will clear all messages in this chat. This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(aiChatProvider.notifier).clearChat(widget.tripId);
              context.pop();
            },
            child: Text(
              'Clear',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}