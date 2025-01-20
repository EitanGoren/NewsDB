import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../backend/server.dart';
import '../data/words_list_widget.dart';

class ShowWordsWidget extends StatefulWidget {
  const ShowWordsWidget({super.key});

  @override
  State<ShowWordsWidget> createState() => _ShowWordsState();
}

class _ShowWordsState extends State<ShowWordsWidget> {
  List<String> articlesList = ['', 'All Articles'];
  late final Map<String, dynamic> _queryServerResponse = {
    'success': true,
    'response': ''
  };
  late final List _wordsList = [];
  late String chosenArtValue = articlesList.first;
  final Map<String, dynamic> _showWordsInfo = {
    'Article': ''
  };

  @override
  void initState(){
    fetchArticlesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Row(children: [
      Expanded(
        flex: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
              width: 450,
              height: 260,
              child: Padding(padding: const EdgeInsets.all(5),
                child: Material(
                  elevation: 15.5,
                  borderRadius: BorderRadius.circular(25),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,),
                              child: Column(
                                children: [
                                  DropdownMenu<String>(
                                    initialSelection: articlesList.first,
                                    onSelected: (String? value) {
                                      setState(() {
                                        chosenArtValue = value!;
                                        _showWordsInfo['Article'] = value;
                                      });
                                    },
                                    hintText: 'Article Name',
                                    expandedInsets: const EdgeInsets.all(0),
                                    textStyle: GoogleFonts.montserrat(fontSize: 20,),
                                    dropdownMenuEntries: articlesList.map<DropdownMenuEntry<String>>((String value) {
                                      return DropdownMenuEntry<String>(value: value, label: value);
                                    }).toList(),
                                  ),
                                ],
                              )
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20,),
                            child: ElevatedButton(
                              onPressed: () async{
                                if(_showWordsInfo['Article'] == '')
                                {
                                  setState(() {
                                    _wordsList.clear();
                                    _queryServerResponse['success'] = false;
                                    _queryServerResponse['response'] = "All boxes are empty,\nFill at least one and try again.";
                                  });
                                  return;
                                }

                                Map? response = await Server.getAllWordsByCriteria(_showWordsInfo);
                                // At least one param is set.
                                setState(() {
                                  _queryServerResponse['success'] = response!['success'];
                                  _queryServerResponse['response'] = response['response'].toString();
                                  if(response['success']){
                                    _wordsList.clear();
                                    for(final word in response['data']){
                                      var cleanWord = word;
                                      cleanWord[0] = cleanWord[0].toString().toLowerCase().replaceAll(',', '').replaceAll('.', '').replaceAll('!', '');
                                      _wordsList.add(cleanWord);
                                    }
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                overlayColor: Colors.blue.shade50,
                                elevation: 15,
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                textStyle: const TextStyle(fontSize: 25, color: Colors.black54,),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child:Text('Fetch Words', style: TextStyle(fontSize: 25, color: Colors.white,),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Text(_queryServerResponse['response'], style: TextStyle(fontSize: 18, color:
                  _queryServerResponse['success'] == true ? Colors.black87 : Colors.red.shade400
                  ),)
              ),
            ],
          ),
        ),
    ),
      Expanded(
        flex: 1,
        child: SizedBox(child: Container(color: Colors.grey.shade50, child: null),),
      ),
      Expanded(
        flex: 270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 12,
              child: Row(
                children: [
                  Expanded(flex: 2, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                  Expanded(flex: 6, child: Center(child: Text('${_wordsList.length} Words Found', style: GoogleFonts.ubuntuMono(fontSize: 32, color: Colors.grey.shade900),))),
                  Expanded(flex: 10, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                ],
              ),
            ),
            Expanded(
              flex: 100,
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: _wordsList.isNotEmpty ? GridView.builder(
                  itemCount: _wordsList.length,
                  itemBuilder: (context, index) {
                    return WordsListWidget(index: index, wordsData: _wordsList,);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisExtent: 60),
                ) : const Center(child: Text("Nothing to show...", style: TextStyle(fontSize: 30, color: Colors.black54),),),
              ),
            ),
          ],
        ),
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
}