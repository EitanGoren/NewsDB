import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhrasesListWidget extends StatefulWidget {
  final int index;
  final List<String> phrasesList;

  const PhrasesListWidget({super.key, required this.index, required this.phrasesList});

  @override
  State<PhrasesListWidget> createState() => _PhrasesListWidgetState();
}

class _PhrasesListWidgetState extends State<PhrasesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(widget.phrasesList[widget.index], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),
      ),
    );
  }
}