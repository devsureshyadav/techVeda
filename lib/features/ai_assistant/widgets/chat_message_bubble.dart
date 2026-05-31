import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech_veda/features/ai_assistant/models/chat_message.dart';
import 'package:tech_veda/features/ai_assistant/widgets/assistant_markdown_styles.dart';
import 'package:tech_veda/features/ai_assistant/widgets/typing_markdown_message.dart';
import 'package:tech_veda/theme/app_theme.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onTypingTick,
    this.onTypingComplete,
  });

  final ChatMessage message;
  final VoidCallback? onTypingTick;
  final VoidCallback? onTypingComplete;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isError = message.isError;

    final bubbleColor = isError
        ? const Color(0xFF3D1515)
        : isUser
            ? AppColors.accent
            : AppColors.surfaceElevated;

    final textColor = isError
        ? const Color(0xFFFF8A80)
        : isUser
            ? Colors.white
            : AppColors.textPrimary;

    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentSecondary.withValues(alpha: 0.2),
              child: Icon(
                isError ? Icons.error_outline : Icons.auto_awesome,
                size: 18,
                color:
                    isError ? const Color(0xFFFF8A80) : AppColors.accentSecondary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: align,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    border: Border.all(
                      color: isError
                          ? const Color(0xFFFF5252).withValues(alpha: 0.4)
                          : AppColors.cardBorder,
                    ),
                  ),
                  child: _MessageBody(
                    message: message,
                    textColor: textColor,
                    onTypingTick: onTypingTick,
                    onTypingComplete: onTypingComplete,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accent.withValues(alpha: 0.35),
              child: const Icon(
                Icons.school_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({
    required this.message,
    required this.textColor,
    this.onTypingTick,
    this.onTypingComplete,
  });

  final ChatMessage message;
  final Color textColor;
  final VoidCallback? onTypingTick;
  final VoidCallback? onTypingComplete;

  @override
  Widget build(BuildContext context) {
    if (message.isUser || message.isError) {
      return Text(
        message.text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          height: 1.45,
          color: textColor,
        ),
      );
    }

    if (message.animateTyping) {
      return TypingMarkdownMessage(
        markdown: message.text,
        textColor: textColor,
        onTick: onTypingTick,
        onComplete: onTypingComplete,
      );
    }

    return MarkdownBody(
      data: message.text,
      styleSheet: assistantMarkdownStyle(textColor: textColor),
      shrinkWrap: true,
      selectable: true,
    );
  }
}
