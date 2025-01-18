import 'package:flutter/material.dart';

class TextSelector extends StatefulWidget {
  const TextSelector({super.key});

  @override
  State<TextSelector> createState() => _TextSelectorState();
}

class _TextSelectorState extends State<TextSelector> {
  final String text =
      "This is a sample text. You can select any length of words, phrases, or sentences.";
  late TextEditingController _controller;

  String selectedText = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: text);
    // Add a listener to track selection changes
    _controller.addListener(() {
      setState(() {
        selectedText = getSelectedText();
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select any text below:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              readOnly: true,
              maxLines: null, // Allow multiple lines
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTapAlwaysCalled: true,
              onTap: () {
                // Update selected text on tap
                Future.delayed(Duration(milliseconds: 100), () {
                  setState(() {
                    selectedText = getSelectedText();
                  });
                });
              }
            ),
            SizedBox(height: 20),
            Text(
              "Selected Text:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              selectedText.isNotEmpty ? selectedText : "No text selected",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
    );
  }

  String getSelectedText() {
    final selection = _controller.selection;
    if (selection.start >= 0 && selection.end >= 0) {
      return text.substring(selection.start, selection.end);
    }
    return "";
  }
}