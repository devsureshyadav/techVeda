import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Gemini API key loaded from `.env` via flutter_dotenv (see `.env.example`).
///
/// Optional override for CI/release:
///   --dart-define=GEMINI_API_KEY=your_key
abstract final class ApiConfig {
  static String get geminiApiKey {
    final fromDotenv = dotenv.env['GEMINI_API_KEY']?.trim();
    if (fromDotenv != null && fromDotenv.isNotEmpty) {
      return fromDotenv;
    }

    const fromDefine = String.fromEnvironment('GEMINI_API_KEY');
    return fromDefine;
  }

  static const geminiModel = 'gemini-flash-latest';

  static const geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static bool get hasGeminiKey => geminiApiKey.isNotEmpty;
}
