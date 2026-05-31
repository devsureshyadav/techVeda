enum ChatRole { user, assistant }

class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.text,
    this.isError = false,
    this.animateTyping = false,
  });

  final ChatRole role;
  final String text;
  final bool isError;

  /// Typewriter + markdown reveal for new assistant replies.
  final bool animateTyping;

  bool get isUser => role == ChatRole.user;

  ChatMessage copyWith({
    String? text,
    bool? isError,
    bool? animateTyping,
  }) {
    return ChatMessage(
      role: role,
      text: text ?? this.text,
      isError: isError ?? this.isError,
      animateTyping: animateTyping ?? this.animateTyping,
    );
  }
}
