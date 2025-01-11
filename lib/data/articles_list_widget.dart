import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/os_operations.dart';
import '../backend/server.dart';

class ArticlesListWidget extends StatefulWidget {
  final int index;
  final List articlesData;

  const ArticlesListWidget({super.key, required this.index, required this.articlesData});

  @override
  State<ArticlesListWidget> createState() => _ArticlesListWidgetState();
}

class _ArticlesListWidgetState extends State<ArticlesListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.articlesData.isNotEmpty ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
          child: SizedBox(
            height: 210,
            width: 170,
            child: Material(
              elevation: 9,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20),),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 11,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Text(widget.articlesData[widget.index][1],
                        style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              await writeWordsToFile(widget.articlesData[widget.index][1], "${widget.articlesData[widget.index][1]}.txt");
                            },
                            icon: const Icon(Icons.download, size: 20, color: Colors.blue,),
                            label: Text('Download', style: GoogleFonts.ubuntuMono(fontSize: 16, color: Colors.black54),),
                            iconAlignment: IconAlignment.end,
                          ),
                        ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: SizedBox(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                String data = await getArticleContentByArticleName(widget.articlesData[widget.index][1]);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: Center(child: Text('${widget.articlesData[widget.index][1]}', style: GoogleFonts.ubuntuMono(fontSize: 35, color: Colors.black87))),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Newspaper: ${widget.articlesData[widget.index][2]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                                Text('Date Published: ${widget.articlesData[widget.index][3]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                                Text('Author: ${widget.articlesData[widget.index][4]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                                Text('Subject: ${widget.articlesData[widget.index][5]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black87),),
                                                SizedBox(height: 20,),
                                                Text(data, style: GoogleFonts.ubuntuMono(fontSize: 18, color: Colors.blue),)
                                              ],
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.open_in_new_rounded, size: 20, color: Colors.red,),
                              label: Text('Open', style: GoogleFonts.ubuntuMono(fontSize: 16, color: Colors.black54),),
                              iconAlignment: IconAlignment.end,
                            ),
                      ),
                    ),
                  ),
                ),
              ],),
            ),
          ),
        ),
    ) : Spacer();
  }
}