import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesIndexListWidget extends StatefulWidget {
  final int index;
  final List<Map<String,dynamic>> statisticsList;

  const ArticlesIndexListWidget({super.key, required this.index, required this.statisticsList});

  @override
  State<ArticlesIndexListWidget> createState() => _ArticlesIndexListWidgetState();
}

class _ArticlesIndexListWidgetState extends State<ArticlesIndexListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 12,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30),),
        color: Colors.grey.shade300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(widget.statisticsList[widget.index]['article_name'], style: GoogleFonts.ubuntuMono(fontSize: 25, color: Colors.black54),),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Column(
                  spacing: 5,
                  children: [
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of words:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                      Expanded(flex:8, child: Text(widget.statisticsList[widget.index]['words_num'], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of lines:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text(widget.statisticsList[widget.index]['lines_num'], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),)
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text(widget.statisticsList[widget.index]['pages_num'], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text(widget.statisticsList[widget.index]['chars_num'], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Avg chars per word:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text(widget.statisticsList[widget.index]['avg_chars_per_word'], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Avg words per line:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text(widget.statisticsList[widget.index]['avg_words_per_line'], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                  ],
                ),
              ),
          ),
        ],),
      ),
    );
  }
}