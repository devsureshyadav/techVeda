import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech_veda/config/api_config.dart';
import 'package:tech_veda/features/ai_assistant/data/gemini_service.dart';
import 'package:tech_veda/features/ai_assistant/models/chat_message.dart';
import 'package:tech_veda/features/ai_assistant/utils/identity_redirect.dart';
import 'package:tech_veda/features/ai_assistant/widgets/chat_message_bubble.dart';
import 'package:tech_veda/theme/app_theme.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _gemini = GeminiService();
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <ChatMessage>[];
  bool _isLoading = false;

  static const _suggestions = [
    'Explain pointers in C simply',
    'What is a Flutter widget?',
    'Python list vs tuple?',
    'SQL JOIN types explained',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage([String? text]) async {
    final question = (text ?? _inputController.text).trim();
    if (question.isEmpty || _isLoading) return;

    HapticFeedback.lightImpact();
    _inputController.clear();
    setState(() {
      _messages.add(ChatMessage(role: ChatRole.user, text: question));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final reply = await _gemini.sendMessage(
        _messages,
        identityQuestion: isIdentityQuestion(question),
      );
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            role: ChatRole.assistant,
            text: reply,
            animateTyping: true,
          ),
        );
        _isLoading = false;
      });
    } on GeminiException catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            role: ChatRole.assistant,
            text: e.message,
            isError: true,
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            role: ChatRole.assistant,
            text: 'Something went wrong. Check your internet and try again.',
            isError: true,
          ),
        );
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Study Assistant',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'TechVeda AI · by Suresh Yadav',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F0252), Color(0xFF12121E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (!ApiConfig.hasGeminiKey) _buildApiKeyBanner(),
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isLoading && index == _messages.length) {
                        return const _TypingIndicator();
                      }
                      final msg = _messages[index];
                      return ChatMessageBubble(
                        key: ValueKey('msg_$index'),
                        message: msg,
                        onTypingTick: _scrollToBottom,
                        onTypingComplete: () {
                          if (!msg.animateTyping || !mounted) return;
                          setState(() {
                            _messages[index] =
                                msg.copyWith(animateTyping: false);
                          });
                          _scrollToBottom();
                        },
                      );
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildApiKeyBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2E00),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: Text(
        'Add GEMINI_API_KEY to your .env file (copy from .env.example).',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          color: Colors.amber[200],
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.4),
                    AppColors.accentSecondary.withValues(alpha: 0.2),
                  ],
                ),
              ),
              child: const Icon(
                Icons.psychology_alt_rounded,
                size: 36,
                color: AppColors.accentSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Stuck on a topic?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask anything about programming, Flutter, Python, databases, or your course guides.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _suggestions.map((s) {
                return ActionChip(
                  label: Text(s),
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.cardBorder),
                  onPressed: _isLoading ? null : () => _sendMessage(s),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        8 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Ask your question...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: _isLoading ? null : () => _sendMessage(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.accentSecondary.withValues(alpha: 0.2),
            child: const Icon(
              Icons.auto_awesome,
              size: 18,
              color: AppColors.accentSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Thinking...',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
