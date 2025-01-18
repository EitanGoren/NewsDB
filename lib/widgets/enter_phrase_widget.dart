import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_db/data/articles_list_widget.dart';

import '../backend/server.dart';
import '../data/phrases_list_widget.dart';
import 'DropDownLabelWidgets/DropDownTextWidget.dart';
import 'EditTextWidgets/edit_text_widget.dart';
import 'TextSelector.dart';

class EnterPhraseWidget extends StatefulWidget {
  const EnterPhraseWidget({super.key});

  @override
  State<EnterPhraseWidget> createState() => _EnterPhraseState();
}

class _EnterPhraseState extends State<EnterPhraseWidget> {
  List<String> articlesList = [];
  List<String> phrasesList = [];
  String selectedOption= 'enter';
  Set<String> selectedWordsList = {};
  Set<String> clickedWordsList = {};
  String selectedWordsString = '';
  String _selectedArticle = '';
  late Map<String,dynamic> _queryServerResponse = {'success': false, 'response': ''};
  final Map<String, dynamic> _newPhraseInfo = {
    'first_word': '',
    'length': int,
    'article_id': ''
  };

  void _updateValue(List<String> values) {
    setState(() {
      _queryServerResponse = {'success': false, 'response': ''};
      if(values.length == 2) {
        if(values.first == 'Enter Phrase'){
          _newPhraseInfo['first_word'] = (values.last).toString().split(' ')[0];
          _newPhraseInfo['length'] = values.length;
        }
        else {
          _newPhraseInfo[values.first] = values.last;
        }
      }
    });
  }

  void _selectArticle(List<String> values) {
    setState(() {
      clickedWordsList.clear();
      selectedWordsList.clear();
      selectedWordsString = '';
      _queryServerResponse = {'success': false, 'response': ''};
      if(values.length == 2) {
        _selectedArticle = values.last;
      }
    });
  }

  void _chosenWords(List<String> values) {
    setState(() {
      if(values.length == 2) {
        if(values.first == 'Enter Phrase'){
          selectedWordsString = values.last;
        }
      }
    });
  }

  @override
  void initState() {
    fetchArticlesList();
    fetchPhrasesList();
    super.initState();
  }

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
                                    child: EditTextWidget(
                                      labelText: 'Enter Phrase',
                                      updateValue: _updateValue,
                                    ),
                                  ),),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_newPhraseInfo['first_word'] == ''){
                                          setState(() {
                                            _queryServerResponse['success'] = false;
                                            _queryServerResponse['response'] = "Missing phrase.. Try Again";
                                          });
                                          return;
                                        }

                                        if(clickedWordsList.isNotEmpty){
                                          _newPhraseInfo['first_word'] = clickedWordsList.first;
                                          _newPhraseInfo['length'] = clickedWordsList.length;
                                        }

                                        Map? response = await Server.defineNewPhrase(_newPhraseInfo);
                                        setState(() {
                                          _queryServerResponse['success'] = response!['success'];
                                          _queryServerResponse['response'] = response['response'].toString();
                                          if(_queryServerResponse['success']){
                                            fetchPhrasesList();
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey.shade600,
                                        overlayColor: Colors.blue.shade50,
                                        elevation: 15,
                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                        textStyle: const TextStyle(fontSize: 25, color: Colors.black54,),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child:Text('Insert Phrase',
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
                        child: TextSelector(),
                        // child: GridView.builder(
                        //   itemCount: articlesList.length,
                        //   itemBuilder: (context, index) {
                        //     return ArticlesListWidget(index: index, articlesData: articlesList,);
                        //   },
                        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        // ),
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
                          itemCount: phrasesList.length,
                          itemBuilder: (context, index) {
                            return PhrasesListWidget(index: index, phrasesList: phrasesList);
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
                        itemCount: phrasesList.length,
                        itemBuilder: (context, index) {
                          return PhrasesListWidget(index: index, phrasesList: phrasesList);
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

  void fetchArticlesList() async {
    List? articles = await Server.getAllArticles();
    if (articles.isNotEmpty) {
      articlesList.clear();
      for (final artName in articles) {
        setState(() {
          articlesList.add(artName[1]);
        });
      }
    }
  }
  void fetchPhrasesList() async{
    List? phrases = await Server.getAllPhrases();
    if(phrases.isNotEmpty){
      phrasesList.clear();
      for(final phrName in phrases){
        setState(() {
          phrasesList.add(phrName[1]);
        });
      }
    }
  }
}
