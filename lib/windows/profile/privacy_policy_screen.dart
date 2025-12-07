import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/screen_utils.dart';
import '../../generated/l10n.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  List<String> _paragraphs(BuildContext context) {
    final body = S.of(context).privacyPolicyBody;
    return body.split('\n\n');
  }

  TextStyle _baseTextStyle(BuildContext context) {
    return TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: ScreenUtils.adaptiveFontSize(context, 12),
      height: 21 / 12,
      letterSpacing: 0,
      color: const Color(0xFF282828),
    );
  }

  TextSpan _buildSpan(BuildContext context, String paragraph) {
    final baseStyle = _baseTextStyle(context);
    final linkStyle = baseStyle.copyWith(
      decoration: TextDecoration.underline,
      color: const Color(0xFF282828),
      decorationColor: const Color(0xFF282828),
    );

    final spans = <TextSpan>[];
    final regex = RegExp(r'https?://[^\s]+');
    int currentIndex = 0;

    for (final match in regex.allMatches(paragraph)) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: paragraph.substring(currentIndex, match.start),
            style: baseStyle,
          ),
        );
      }
      final url = match.group(0)!;
      spans.add(
        TextSpan(
          text: url,
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // URL launcher can be integrated here when needed
              // For now, URLs are displayed as clickable text
            },
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < paragraph.length) {
      spans.add(
        TextSpan(text: paragraph.substring(currentIndex), style: baseStyle),
      );
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final paragraphs = _paragraphs(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF282828)),
        ),
        title: SizedBox(
          width: ScreenUtils.adaptiveWidth(context, 48),
          height: ScreenUtils.adaptiveHeight(context, 50),
          child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.adaptiveWidth(context, 16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
                Text(
                  s.privacyPolicyTitle.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtils.adaptiveFontSize(context, 14),
                    height: 23 / 14,
                    letterSpacing: 0,
                    color: const Color(0xFF282828),
                  ),
                ),
                SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
                for (int i = 0; i < paragraphs.length; i++) ...[
                  Text.rich(
                    _buildSpan(context, paragraphs[i]),
                    textAlign: TextAlign.left,
                  ),
                  if (i != paragraphs.length - 1)
                    SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
                ],
                SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
