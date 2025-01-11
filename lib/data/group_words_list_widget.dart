import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupWordsListWidget extends StatefulWidget {
  int index;
  List wordsData;
  Set clickedWordsList;

  GroupWordsListWidget({super.key, required this.index, required this.wordsData, required this.clickedWordsList});

  @override
  State<GroupWordsListWidget> createState() => _GroupWordsListWidgetState();
}

class _GroupWordsListWidgetState extends State<GroupWordsListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.wordsData.isNotEmpty ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 10,
          shadowColor: Colors.grey.shade700,
          color: widget.clickedWordsList.contains(widget.wordsData[widget.index]) ? Colors.redAccent : Colors.white ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: 20,
            child: TextButton(
              onPressed: () {
                setState(() {
                  widget.clickedWordsList.add(widget.wordsData[widget.index]);
                });
              },
              child: Center(child: Text('${widget.wordsData[widget.index]}', style: GoogleFonts.ubuntuMono(fontSize: 15, color: Colors.black87),),),
            ),
          ),
        ),
    ) : Spacer();
  }
}