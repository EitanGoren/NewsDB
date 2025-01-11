import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WordsPickListWidget extends StatefulWidget {
  final int index;

  const WordsPickListWidget({super.key, required this.index});

  @override
  State<WordsPickListWidget> createState() => _WordsPickListWidgetState();
}

class _WordsPickListWidgetState extends State<WordsPickListWidget> {
  Icon icon = const Icon(Icons.star_border);

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () {
        setState(() {
          icon = const Icon(Icons.star);
        });
      },
      icon: icon,
      label: Text('Word ${widget.index}', style: GoogleFonts.ubuntuMono(fontSize: 18, color: Colors.black54),),
      iconAlignment: IconAlignment.end,
    );
  }
}