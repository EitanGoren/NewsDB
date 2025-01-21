import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/os_operations.dart';
import '../backend/server.dart';
import 'HighlightedTextWidget.dart';

class PhraseInfoInArticleWidget extends StatefulWidget {
  final int index;
  final Map<String,dynamic> phraseData;

  const PhraseInfoInArticleWidget({super.key, required this.index, required this.phraseData});

  @override
  State<PhraseInfoInArticleWidget> createState() => _PhraseInfoInArticleWidgetState();
}

class _PhraseInfoInArticleWidgetState extends State<PhraseInfoInArticleWidget> {
  String articleName = '';
  @override
  void initState() {
    fetchArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Map? data = await Server.getPhraseInfo(widget.phraseData);
        print(data!['data']);
        String article = await getArticleContentByArticleName(articleName);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: Center(child: Text(articleName, style: GoogleFonts.ubuntuMono(fontSize: 35, color: Colors.black87))),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    child: Column(
                      children: [
                        // Text(article, style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),
                        SizedBox(height: 30,),
                        buildHighlightedText(article, widget.phraseData['phrase']),
                      ],
                    )
                ),
              ),
            );
          },
        );
      }, child: Text(widget.phraseData['phrase']!.toString().replaceAll('\n', ', '), style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),
    );
  }

  void fetchArticles() async{
    List? arts = await Server.getAllArticles();
    for(var a in arts) {
      if(a[0] == widget.phraseData['article_id']){
        setState(() {
          articleName = a[1];
          return;
        });
      }
    }
  }
}
