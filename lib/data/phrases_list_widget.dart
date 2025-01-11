import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhrasesListWidget extends StatefulWidget {
  final int index;

  const PhrasesListWidget({super.key, required this.index});

  @override
  State<PhrasesListWidget> createState() => _PhrasesListWidgetState();
}

class _PhrasesListWidgetState extends State<PhrasesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Material(
        elevation: 9,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Phrase ${widget.index}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),
              ),
            ),
        ],),
      ),
    );
  }
}