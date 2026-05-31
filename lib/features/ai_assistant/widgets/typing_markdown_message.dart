import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech_veda/features/ai_assistant/widgets/assistant_markdown_styles.dart';
import 'package:tech_veda/theme/app_theme.dart';

/// Reveals [markdown] with a typewriter effect, rendered as Markdown.
class TypingMarkdownMessage extends StatefulWidget {
  const TypingMarkdownMessage({
    super.key,
    required this.markdown,
    this.textColor,
    this.onTick,
    this.onComplete,
  });

  final String markdown;
  final Color? textColor;
  final VoidCallback? onTick;
  final VoidCallback? onComplete;

  @override
  State<TypingMarkdownMessage> createState() => _TypingMarkdownMessageState();
}

class _TypingMarkdownMessageState extends State<TypingMarkdownMessage> {
  Timer? _timer;
  int _visibleChars = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    final total = widget.markdown.length;
    if (total == 0) {
      _finished = true;
      widget.onComplete?.call();
      return;
    }

    final durationMs = (total * 22).clamp(600, 9000);
    final stepMs = (durationMs / total).round().clamp(8, 40);

    _timer = Timer.periodic(Duration(milliseconds: stepMs), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _visibleChars++;
        if (_visibleChars >= total) {
          _visibleChars = total;
          _finished = true;
          timer.cancel();
        }
      });
      widget.onTick?.call();
      if (_finished) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.markdown.substring(
      0,
      _visibleChars.clamp(0, widget.markdown.length),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownBody(
          data: visible.isEmpty ? ' ' : visible,
          styleSheet: assistantMarkdownStyle(textColor: widget.textColor),
          shrinkWrap: true,
          selectable: _finished,
        ),
        if (!_finished)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: _BlinkingCursor(color: widget.textColor ?? AppColors.accentSecondary),
          ),
      ],
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor({required this.color});

  final Color color;

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _visible = !_visible);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '|',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: _visible ? widget.color : Colors.transparent,
      ),
    );
  }
}
