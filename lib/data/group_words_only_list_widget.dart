import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupWordsOnlyListWidget extends StatefulWidget {
  final int index;
  final List wordsData;

  const GroupWordsOnlyListWidget({super.key, required this.index, required this.wordsData});

  @override
  State<GroupWordsOnlyListWidget> createState() => _GroupWordsOnlyListState();
}

class _GroupWordsOnlyListState extends State<GroupWordsOnlyListWidget> {

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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Center(child: Text('${widget.wordsData[widget.index]}', style: GoogleFonts.ubuntuMono(fontSize: 35, color: Colors.black87))),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            child:Spacer(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Center(child: Text('${widget.wordsData[widget.index]}', style: GoogleFonts.ubuntuMono(fontSize: 15, color: Colors.black87),),),
              // label: Text('Index', style: GoogleFonts.ubuntuMono(fontSize: 14, color: Colors.black54),),
            ),
          ),
        ),
    ) : Spacer();
  }
}