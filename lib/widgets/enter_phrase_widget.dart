import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/os_operations.dart';
import '../backend/server.dart';
import '../data/phrases_list_widget.dart';
import 'TextSelector.dart';

class EnterPhraseWidget extends StatefulWidget {
  const EnterPhraseWidget({super.key});

  @override
  State<EnterPhraseWidget> createState() => _EnterPhraseState();
}

class _EnterPhraseState extends State<EnterPhraseWidget> {
  late List<Map<String, String>> articlesDataMap = [];
  Map<String, String> chosenArticleData = {};
  List<Map<String, String>> phrasesData = [];
  String articleText = '';
  final Map<String,dynamic> _queryServerResponse = {'success': false, 'response': ''};
  final Map<String, dynamic> _newPhraseInfo = {
    'phrase': '',
    'length': int,
    'article_id': '',
  };

  void _chosenPhrase(String text) {
      // Split by spaces and punctuation
      List<String> words = text.split(' ');
      // Remove empty strings if any
      words = words.where((word) => word.isNotEmpty).toList();
      if(words.isNotEmpty) {
        _newPhraseInfo['phrase'] = text;
        _newPhraseInfo['length'] = words.length;
        _newPhraseInfo['article_id'] = chosenArticleData['id'];
      }
  }

  @override
  void initState() {
    fetchArticlesList();
    fetchPhrases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 340,
                        height: 220,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                  child: Center(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15,),
                                        child: DropdownMenu<Map<String,String>>(
                                          initialSelection: articlesDataMap.isNotEmpty ? articlesDataMap.first : null,
                                          onSelected: (Map<String,String>? value) async {
                                            String? artName = value != null ? value['name'] : "";
                                            String data = await getArticleContentByArticleName(artName!);
                                            setState(() {
                                              chosenArticleData = value!;
                                              articleText = data;
                                            });
                                          },
                                          hintText: 'Article Name',
                                          expandedInsets: const EdgeInsets.all(0),
                                          textStyle: GoogleFonts.montserrat(fontSize: 20,),
                                          dropdownMenuEntries: articlesDataMap
                                              .map(
                                                (article) => DropdownMenuEntry<Map<String,String>>(
                                              value: article,
                                              label: article["name"] ?? "Unnamed",
                                            ),
                                          ).toList(),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_newPhraseInfo['phrase'] == '' || _newPhraseInfo['length'] <= 0){
                                          setState(() {
                                            _queryServerResponse['success'] = false;
                                            _queryServerResponse['response'] = "Missing phrase.. Try Again";
                                          });
                                          return;
                                        }
                              
                                        Map? response = await Server.defineNewPhrase(_newPhraseInfo);
                                        setState(() {
                                          _queryServerResponse['success'] = response!['success'];
                                          _queryServerResponse['response'] = response['response'].toString();
                                          if(_queryServerResponse['success']){
                                            fetchPhrases();
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
                                        padding: EdgeInsets.all(10),
                                        child:Text('Insert Phrase',
                                          style: TextStyle(fontSize: 22, color: Colors.white,),),
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
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('All Phrases in DB', style: GoogleFonts.ubuntuMono(fontSize: 28, color: Colors.black87),),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: ListView.builder(
                              itemCount: phrasesData.length,
                              itemBuilder: (context, index) {
                                return PhrasesListWidget(index: index, phrasesData: phrasesData);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(padding: const EdgeInsets.all(15),
                child: TextSelector(articleText: articleText, chosenPhrase: _chosenPhrase,),
              )
            ),
        ],),
      ),
    );
  }
  void fetchArticlesList() async{
    List? response = await Server.getAllArticles();
    if(response.isNotEmpty){
      articlesDataMap.clear();
      for(final article in response){
        setState(() {
          articlesDataMap.add({
            'id': article[0],
            'name': article[1],
            'newspaper': article[2],
            'date': article[3],
            'author': article[4],
            'header': article[5]
          });
        });
      }
    }
  }
  void fetchPhrases() async{
    List? phrases = await Server.getAllPhrases();

    if(phrases.isNotEmpty){
      phrasesData.clear();
      for(final p in phrases){
        setState(() {
          phrasesData.add({
            'phrase_id': p[0],
            'phrase': p[2],
            'article_id': p[1]
          });
        });
      }
    }
  }
}
