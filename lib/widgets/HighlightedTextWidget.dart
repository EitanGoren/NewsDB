import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildHighlightedText(String text, String wordToHighlight) {
  // Create a regular expression to match the exact word
  RegExp regex = RegExp(r'\b' + RegExp.escape(wordToHighlight.trim()) + r'(?!\w)', caseSensitive: false);

  // Split the text into parts using the matching word
  List<TextSpan> spans = [];
  int start = 0;

  // Iterate over all matches
  for (var match in regex.allMatches(text)) {
    // Add the text before the matching word
    if (match.start > start) {
      spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),
      ));
    }

    // Add the matching word with red color
    spans.add(TextSpan(
        text: match.group(0),
        style: GoogleFonts.ubuntuMono(fontSize: 23, color: Colors.red.shade900, fontWeight: FontWeight.bold)
    ));

    // Update the start position
    start = match.end;
  }

  // Add any remaining text after the last match
  if (start < text.length) {
    spans.add(TextSpan(
        text: text.substring(start),
        style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),
    ));
  }

  // Return a RichText widget containing the styled spans
  return RichText(
    text: TextSpan(children: spans),
  );
}