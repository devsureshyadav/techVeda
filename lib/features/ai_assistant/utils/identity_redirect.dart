/// True only for direct questions about the assistant itself (not study topics).
bool isIdentityQuestion(String message) {
  final q = message.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  // Long messages are almost always coursework, not "who are you".
  if (q.length > 100) return false;

  final patterns = [
    RegExp(r'^who (built|made|created|developed|designed) (you|this|tech\s*veda|the ai)\??$'),
    RegExp(r'^who are you\??$'),
    RegExp(r'^what are you\??$'),
    RegExp(r"^what('s| is) your name\??$"),
    RegExp(r'^your name\??$'),
    RegExp(r'^are you (google|gemini|chat\s*gpt|gpt|openai|an? ai)\??$'),
    RegExp(r'^are you from google\??$'),
    RegExp(r'^who (is|was) your (creator|developer|maker)\??$'),
    RegExp(r'^who owns you\??$'),
    RegExp(r'^tell me about yourself\??$'),
    RegExp(r'^introduce yourself\??$'),
  ];

  return patterns.any((p) => p.hasMatch(q));
}
