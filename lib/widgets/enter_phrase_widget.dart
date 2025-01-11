import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_db/data/articles_list_widget.dart';

import '../data/phrases_list_widget.dart';

class EnterPhraseWidget extends StatefulWidget {
  const EnterPhraseWidget({super.key});

  @override
  State<EnterPhraseWidget> createState() => _EnterPhraseState();
}

class _EnterPhraseState extends State<EnterPhraseWidget> {
  List<String> articlesList = <String>['All Articles', 'Article 1', 'Article 2', 'Article 3', 'Article 4'];
  String selectedOption = 'article';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Column(
        children: [
          Expanded(
            flex: 190,
            child: Row(children: [
              Expanded(
                flex: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.all(10),
                      child: Material(
                        elevation: 12,
                        borderRadius: BorderRadius.circular(25),
                        child: SegmentedButton<String>(
                          onSelectionChanged: (Set<String> value) {
                            setState(() {
                              selectedOption = value.first;
                            });
                          },
                          selected: <String>{selectedOption},
                          segments: <ButtonSegment<String>>[
                            ButtonSegment<String>(
                              value: 'article',
                              label: Text('From article', style: GoogleFonts.yantramanav(fontSize: 20, color: Colors.black54),),
                            ),
                            ButtonSegment<String>(
                              value: 'enter',
                              label: Text('Write phrase', style: GoogleFonts.yantramanav(fontSize: 20, color: Colors.black54),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SizedBox(
                        width: 500,
                        height: 270,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                      child: TextFormField(
                                        enabled: selectedOption == "enter" ? true : false,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'Enter Phrase',
                                          labelStyle: GoogleFonts.montserrat(fontSize: 20,),
                                        ),
                                      ),
                                    ),
                                  ),),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                          if (selectedOption == "enter") {
                                            // do stuff
                                          }
                                          else {
                                            // do nothing
                                          }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        enableFeedback: selectedOption == "enter" ? true : false,
                                        backgroundColor: Colors.blueGrey.shade600,
                                        overlayColor: Colors.blue.shade50,
                                        elevation: 15,
                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                        textStyle: const TextStyle(fontSize: 25, color: Colors.black54,),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child:Text('Save Phrase',
                                          style: TextStyle(fontSize: 25, color: Colors.white,),),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 200,
                child: selectedOption == "article" ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(padding: const EdgeInsets.all(15),
                        child: GridView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ArticlesListWidget(index: index, articlesData: [],);
                          },
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        ),
                      ),
                  ),
                ],)
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text('Phrase Found in DB', style: GoogleFonts.ubuntuMono(fontSize: 32, color: Colors.black54),),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 5),
                          child: ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return PhrasesListWidget(index: index);
                            },
                            padding: const EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                    ],
                ),
              ),
            ],),
          ),
          Expanded(
            flex: 15,
            child: Row(
              children: [
                Expanded(flex: 15, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                Expanded(flex: 25, child: Center(child: Text('Phrases list', style: GoogleFonts.ubuntuMono(fontSize: 30, color: Colors.grey.shade900),))),
                Expanded(flex: 100, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
              ],
            ),
          ),
          Expanded(
            flex: 150,
            child: SizedBox(
              width: 900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      child: ListView.builder(
                        itemCount: 40,
                        itemBuilder: (context, index) {
                          return PhrasesListWidget(index: index);
                        },
                        padding: const EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                ],),
            ),
          ),
        ],
      ),
    );
  }
}
