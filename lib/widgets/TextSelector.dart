import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextSelector extends StatefulWidget {
  final String articleText;
  final ValueChanged<String> chosenPhrase;

  const TextSelector({super.key, required this.articleText, required this.chosenPhrase});

  @override
  State<TextSelector> createState() => _TextSelectorState();
}

class _TextSelectorState extends State<TextSelector> {
  late TextEditingController _controller;
  String selectedText = "";

  @override
  void didUpdateWidget(covariant TextSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the articleText has changed
    if (oldWidget.articleText != widget.articleText) {
      setState(() {
        _controller = TextEditingController(text: widget.articleText);
        _controller.addListener(() {
          setState(() {
            selectedText = getSelectedText();
            widget.chosenPhrase(selectedText);
          });
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.articleText);

    // Add a listener to track selection changes
    _controller.addListener(() {
      setState(() {
        selectedText = getSelectedText();
        widget.chosenPhrase(selectedText);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Select any phrase from article",
              style: GoogleFonts.ubuntuMono(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 8),
            TextField(
              controller: _controller,
              readOnly: true,
              maxLines: 10, // Allow multiple lines
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTapAlwaysCalled: false,
              onTap: () {
                // Update selected text on tap
                Future.delayed(Duration(milliseconds: 100), () {
                  setState(() {
                    selectedText = getSelectedText();
                  });
                });
              }
            ),
            SizedBox(height: 15),
            Text(
              "Selected Phrase:",
               style: GoogleFonts.ubuntuMono(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 5),
            selectedText.isNotEmpty ? Text(selectedText,
              style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),) : Text( "No text selected",
              style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),)
          ],
        ),
    );
  }

  String getSelectedText() {
    final selection = _controller.selection;
    if (selection.start >= 0 && selection.end >= 0) {
      return widget.articleText.substring(selection.start, selection.end);
    }
    return "";
  }
}