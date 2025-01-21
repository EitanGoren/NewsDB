import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/os_operations.dart';
import '../widgets/HighlightedTextWidget.dart';

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
                String data = await getArticleContentByArticleName(widget.wordsData[widget.index][0]);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Center(child: Text('${widget.wordsData[widget.index][5]}', style: GoogleFonts.ubuntuMono(fontSize: 35, color: Colors.black87))),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Article Name: ${widget.wordsData[widget.index][0]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.red),),
                                Text('Length: ${widget.wordsData[widget.index][4]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                Text('Page: ${widget.wordsData[widget.index][1]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                Text('Line in page: ${widget.wordsData[widget.index][2]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                Text('Place in line: ${widget.wordsData[widget.index][3]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                SizedBox(height: 30,),
                                buildHighlightedText(data, widget.wordsData[widget.index][5]),
                              ],
                            )
                        ),
                      ),
                    );
                  },
                );
              },
              child: Center(child: Text('${widget.wordsData[widget.index][5]}', style: GoogleFonts.ubuntuMono(fontSize: 15, color: Colors.black87),),),
              // label: Text('Index', style: GoogleFonts.ubuntuMono(fontSize: 14, color: Colors.black54),),
            ),
          ),
        ),
    ) : Spacer();
  }
}
