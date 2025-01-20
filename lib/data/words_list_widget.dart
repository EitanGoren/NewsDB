import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/os_operations.dart';

class WordsListWidget extends StatefulWidget {
  final int index;
  final List wordsData;

  const WordsListWidget({super.key, required this.index, required this.wordsData});

  @override
  State<WordsListWidget> createState() => _WordsListWidgetState();
}

class _WordsListWidgetState extends State<WordsListWidget> {

  @override
  Widget build(BuildContext context) {
    return widget.wordsData.isNotEmpty ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 10,
          shadowColor: Colors.grey.shade700,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: 40,
            child: TextButton(
              onPressed: () async{
                String data = await getArticleContentByArticleName(widget.wordsData[widget.index][5]);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Center(child: Text('${widget.wordsData[widget.index][0]}', style: GoogleFonts.ubuntuMono(fontSize: 35, color: Colors.black87))),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Article Name: ${widget.wordsData[widget.index][5]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.red),),
                                Text('Length: ${widget.wordsData[widget.index][1]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                Text('Page: ${widget.wordsData[widget.index][2]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                Text('Line in page: ${widget.wordsData[widget.index][3]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                Text('Place in line: ${widget.wordsData[widget.index][4]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                SizedBox(height: 30,),
                                buildHighlightedText(data, widget.wordsData[widget.index][0]),
                              ],
                            )
                        ),
                      ),
                    );
                  },
                );
              },
              child: Center(child: Text('${widget.wordsData[widget.index][0]}', style: GoogleFonts.ubuntuMono(fontSize: 15, color: Colors.black87),),),
              // label: Text('Index', style: GoogleFonts.ubuntuMono(fontSize: 14, color: Colors.black54),),
            ),
          ),
        ),
    ) : Spacer();
  }
}

Widget buildHighlightedText(String text, String wordToHighlight) {
  // Create a regular expression to match the exact word
  RegExp regex = RegExp(r'\b' + RegExp.escape(wordToHighlight) + r'(?!\w)', caseSensitive: false);

  // Split the text into parts using the matching word
  List<TextSpan> spans = [];
  int start = 0;

  // Iterate over all matches
  for (var match in regex.allMatches(text)) {
    // Add the text before the matching word
    if (match.start > start) {
      spans.add(TextSpan(
        text: text.substring(start, match.start),
        style: GoogleFonts.ubuntuMono(fontSize: 22, color: Colors.black87)
      ));
    }

    // Add the matching word with red color
    spans.add(TextSpan(
      text: match.group(0),
      style: GoogleFonts.ubuntuMono(fontSize: 26, color: Colors.red, fontWeight: FontWeight.bold)
    ));

    // Update the start position
    start = match.end;
  }

  // Add any remaining text after the last match
  if (start < text.length) {
    spans.add(TextSpan(
      text: text.substring(start),
      style: GoogleFonts.ubuntuMono(fontSize: 22, color: Colors.black87)
    ));
  }

  // Return a RichText widget containing the styled spans
  return RichText(
    text: TextSpan(children: spans),
  );
}
