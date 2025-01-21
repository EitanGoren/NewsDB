import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/server.dart';
import '../widgets/phrase_info_in_article_widget.dart';

class PhrasesListWidget extends StatefulWidget {
  final int index;
  final List<Map<String, String>> phrasesData;

  const PhrasesListWidget({super.key, required this.index, required this.phrasesData});

  @override
  State<PhrasesListWidget> createState() => _PhrasesListWidgetState();
}

class _PhrasesListWidgetState extends State<PhrasesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: PhraseInfoInArticleWidget(index: widget.index, phraseData: widget.phrasesData[widget.index]),
      ),
    );
  }
}