import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech_veda/theme/app_theme.dart';

MarkdownStyleSheet assistantMarkdownStyle({Color? textColor}) {
  final color = textColor ?? AppColors.textPrimary;
  final base = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    height: 1.5,
    color: color,
  );

  return MarkdownStyleSheet(
    p: base,
    pPadding: const EdgeInsets.only(bottom: 6),
    strong: base.copyWith(fontWeight: FontWeight.w700),
    em: base.copyWith(fontStyle: FontStyle.italic),
    h1: base.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
    h2: base.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
    h3: base.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    listBullet: base,
    listIndent: 20,
    blockSpacing: 8,
    blockquote: base.copyWith(color: AppColors.textSecondary),
    blockquoteDecoration: BoxDecoration(
      border: Border(
        left: BorderSide(color: AppColors.accentSecondary, width: 3),
      ),
    ),
    blockquotePadding: const EdgeInsets.only(left: 12),
    code: TextStyle(
      fontFamily: 'monospace',
      fontSize: 13,
      color: AppColors.accentSecondary,
      backgroundColor: Colors.black.withValues(alpha: 0.35),
    ),
    codeblockDecoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(8),
    ),
    codeblockPadding: const EdgeInsets.all(10),
    a: base.copyWith(
      color: AppColors.accentSecondary,
      decoration: TextDecoration.underline,
    ),
  );
}
