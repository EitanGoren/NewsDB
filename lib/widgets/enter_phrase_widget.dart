import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/os_operations.dart';
import '../backend/server.dart';
import '../data/phrases_list_widget.dart';
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
  String articleText = '';
  late String chosenArtValue = '';
  late Map<String,dynamic> _queryServerResponse = {'success': false, 'response': ''};
  final Map<String, dynamic> _newPhraseInfo = {
    'phrase': '',
    'length': int,
    'article_name': ''
  };

  void _updateValue(List<String> values) {
    setState(() {
      _queryServerResponse = {'success': false, 'response': ''};
      if (values.length == 2) {
        if (values.first == 'Enter Phrase') {
          _newPhraseInfo['phrase'] = (values.last).toString();
          _newPhraseInfo['length'] = values.length;
          _newPhraseInfo['article_name'] = chosenArtValue;
        }
        else {
          _newPhraseInfo[values.first] = values.last;
        }
      }
    });
  }

  void _chosenPhrase(String text) {
      // Split by spaces and punctuation
      List<String> words = text.split(' ');

      // Remove empty strings if any
      words = words.where((word) => word.isNotEmpty).toList();

      if(words.isNotEmpty) {
        _newPhraseInfo['phrase'] = text;
        _newPhraseInfo['length'] = words.length;
        _newPhraseInfo['article_name'] = chosenArtValue;
        print(_newPhraseInfo);
      }
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
      body: Row(children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 270,
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
                                child: DropdownMenu<String>(
                                  initialSelection: articlesList.isNotEmpty ? articlesList.first : "",
                                  onSelected: (String? value) async {
                                    String data = await getArticleContentByArticleName(value!);
                                    setState(() {
                                      chosenArtValue = value;
                                      articleText = data;
                                    });
                                  },
                                  hintText: 'Article Name',
                                  expandedInsets: const EdgeInsets.all(0),
                                  textStyle: GoogleFonts.montserrat(fontSize: 20,),
                                  dropdownMenuEntries: articlesList.map<DropdownMenuEntry<String>>((String value) {
                                    return DropdownMenuEntry<String>(value: value, label: value);
                                  }).toList(),
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
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(padding: const EdgeInsets.all(15),
                  child: Center(child: TextSelector(articleText: articleText, chosenPhrase: _chosenPhrase, articleName: chosenArtValue,)),
                ),
              ),
              Expanded(
                flex: 2,
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
                          itemCount: phrasesList.length,
                          itemBuilder: (context, index) {
                            return PhrasesListWidget(index: index, phrasesList: phrasesList);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      ],),
    );
  }
  void fetchArticlesList() async{
    List? response = await Server.getAllArticles();
    if(response.isNotEmpty){
      articlesList.clear();
      articlesList.add('');
      articlesList.add('All Articles');
      for(final artName in response){
        setState(() {
          articlesList.add(artName[1]);
        });
      }
      print(articlesList);
    }
  }
  void fetchPhrasesList() async{
    List? phrases = await Server.getAllPhrases();
    if(phrases.isNotEmpty){
      phrasesList.clear();
      for(final p in phrases){
        setState(() {
          String phrase = p[2].toString().replaceAll('\n', ', ');
          phrasesList.add(phrase);
        });
      }
    }
  }
}
