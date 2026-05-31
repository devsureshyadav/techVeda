import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tech_veda/config/api_config.dart';
import 'package:tech_veda/features/ai_assistant/models/chat_message.dart';

class GeminiException implements Exception {
  GeminiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class GeminiService {
  static const _systemPrompt = '''
You are the study assistant inside the TechVeda app. Help students learn programming: C, Dart, Flutter, Python, databases, app development, and ethical hacking basics.

How to answer:
- Focus on the student's question. Be natural, friendly, and conversational—like a helpful tutor, not a brochure.
- Use Markdown when useful (bold, lists, `code`, short code blocks).
- Give clear steps and small examples. If unsure, say so briefly.
- Do NOT introduce yourself or mention who built you unless they explicitly ask about you, your name, your creator, or whether you are Gemini/Google/ChatGPT.
- Never repeat the same opening line or self-description across messages.
- Only if they ask about your identity or origins: say you are TechVeda AI, built by Suresh Yadav to help students in this app—not Google Gemini or ChatGPT. Keep that answer short (2–4 sentences), then offer to help with a topic.
- Do not help with illegal hacking or bypassing security.
''';

  Uri get _endpoint => Uri.parse(
        '${ApiConfig.geminiBaseUrl}/${ApiConfig.geminiModel}:generateContent',
      );

  Future<String> sendMessage(
    List<ChatMessage> history, {
    bool identityQuestion = false,
  }) async {
    if (!ApiConfig.hasGeminiKey) {
      throw GeminiException(
        'Gemini API key is not set. Add GEMINI_API_KEY to your .env file '
        '(see .env.example).',
      );
    }

    final recent = history.where((m) => !m.isError).toList();
    final trimmed =
        recent.length > 20 ? recent.sublist(recent.length - 20) : recent;

    final contents = <Map<String, dynamic>>[];
    for (final msg in trimmed) {
      contents.add({
        'role': msg.isUser ? 'user' : 'model',
        'parts': [
          {'text': msg.text},
        ],
      });
    }

    if (contents.isEmpty) {
      throw GeminiException('Please enter a question first.');
    }

    final systemText = identityQuestion
        ? '$_systemPrompt\n\nThe student is asking about YOU (identity/origins). Answer naturally in 2–4 sentences: you are TechVeda AI, built by Suresh Yadav for this app to help students learn. You are not Google Gemini or ChatGPT. Then invite them to ask a study question. Do not use a scripted template—vary your wording.'
        : _systemPrompt;

    final body = jsonEncode({
      'systemInstruction': {
        'parts': [
          {'text': systemText},
        ],
      },
      'contents': contents,
    });

    final response = await http
        .post(
          _endpoint,
          headers: {
            'Content-Type': 'application/json',
            'X-goog-api-key': ApiConfig.geminiApiKey,
          },
          body: body,
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      final error = _parseError(response.body);
      throw GeminiException(
        error ?? 'Request failed (${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final text = json['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (text is! String || text.trim().isEmpty) {
      throw GeminiException('No response from the assistant. Try again.');
    }

    return text.trim();
  }

  String? _parseError(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final message = json['error']?['message'];
      if (message is String && message.isNotEmpty) return message;
    } catch (_) {}
    return null;
  }
}
