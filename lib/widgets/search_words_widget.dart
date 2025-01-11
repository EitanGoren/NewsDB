import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_db/widgets/DropDownLabelWidgets/DropDownTextWidget.dart';

import '../backend/server.dart';
import '../data/words_list_widget.dart';

class SearchWordsWidget extends StatefulWidget {
  const SearchWordsWidget({super.key});

  @override
  State<SearchWordsWidget> createState() => _SearchWordsState();
}

class _SearchWordsState extends State<SearchWordsWidget> {
  List<String> articlesList = [''];
  List<dynamic> articlesAllInfoList = [];
  Set<String> pageList = {''};
  Set<String> lineList = {''};
  Set<String> placeInLineList = {''};
  Set<String> lengthsList = {''};
  late Map<String, dynamic> _queryServerResponse = {
    'success': true,
    'response': ''
  };
  late List _wordsList = [];
  late String? articleValue = articlesList.first;
  late String? pageValue = pageList.first;
  late String? lineValue = lineList.first;
  late String? placeInLineValue = placeInLineList.first;
  late String? lengthsValue = lengthsList.first;
  final Map<String, dynamic> _searchWordsInfo = {
    'Article': '',
    'Page': '',
    'Line': '',
    'Length': '',
    'PlaceInLine': '',
  };

  void _updateValue(List<String> values) {
    setState(() {
      _queryServerResponse = {'success': false, 'response': ''};
      if(values.length == 2) {
        _searchWordsInfo[values.first] = values.last;
      }
    });
  }

  @override
  void initState(){
    fetchArticlesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Row(children: [
        Expanded(
          flex: 170,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 450,
                  height: 650,
                  child: Padding(padding: const EdgeInsets.all(5),
                    child: Material(
                      elevation: 15.5,
                      borderRadius: BorderRadius.circular(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  child: Column(
                                    children: [
                                      DropdownMenu<String>(
                                        initialSelection: articlesList.first,
                                        onSelected: (String? value) async{
                                          setState(() {
                                            articleValue = value!;
                                            _searchWordsInfo['Article'] = value;
                                          });

                                          List<String> artIds = [];
                                          for(final art in articlesAllInfoList){
                                            if(art[1] == value) {
                                              artIds.add(art[0]);
                                            }
                                          }

                                          Map? response = await Server.getWordsByArticleInfo(artIds);
                                          setState(() {
                                            _queryServerResponse['success'] = response!['success'];
                                            _queryServerResponse['response'] = response['response'].toString();
                                            if(response['success']){
                                              pageList = {...response['pages']};
                                              lineList = {...response['lines']};
                                              lengthsList = {...response['lengths']};
                                              placeInLineList = {...response['place_in_line']};

                                              pageList.add("");pageList.addAll(pageList);
                                              lineList.add("");lineList.addAll(lineList);
                                              lengthsList.add("");lengthsList.addAll(lengthsList);
                                              placeInLineList.add("");placeInLineList.addAll(placeInLineList);

                                              pageValue = '';
                                              lineValue = '';
                                              lengthsValue = '';
                                              placeInLineValue = '';
                                            }
                                          });
                                        },
                                        hintText: 'Article Name',
                                        expandedInsets: const EdgeInsets.all(0),
                                        textStyle: GoogleFonts.montserrat(fontSize: 20,),
                                        dropdownMenuEntries: articlesList.map<DropdownMenuEntry<String>>((String value) {
                                          return DropdownMenuEntry<String>(value: value, label: value);
                                        }).toList(),
                                      )
                                  ],)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  child: DropDownTextWidget(
                                    labelText: 'Page',
                                    updateValue: _updateValue,
                                    dataList: pageList,
                                  ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: DropDownTextWidget(
                                  labelText: 'Line',
                                  updateValue: _updateValue,
                                  dataList: lineList,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: DropDownTextWidget(
                                  labelText: 'PlaceInLine',
                                  updateValue: _updateValue,
                                  dataList: placeInLineList,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: DropDownTextWidget(
                                  labelText: 'Length',
                                  updateValue: _updateValue,
                                  dataList: lengthsList,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                              child: ElevatedButton(
                                onPressed: () async{
                                  Map? response = await Server.searchWordsByParams(_searchWordsInfo);
                                  setState(() {
                                    _queryServerResponse['success'] = response!['success'];
                                    _queryServerResponse['response'] = response['response'].toString();
                                    if(response['success']){
                                      _wordsList = response['data'];
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
                                  child:Text('Search Words', style: TextStyle(fontSize: 25, color: Colors.white,),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
          child: SizedBox(child: Container(color: Colors.grey.shade50),),
        ),
        Expanded(
          flex: 220,
          child: Column(
            children: [
            Expanded(
              flex: 50,
              child: Row(
                children: [
                  Expanded(flex: 2, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                  Expanded(flex: 11, child:
                  Center(
                      child: Text('${_wordsList.length} Words from ${articleValue == '' ? 'All Articles' : articleValue}',
                        style: GoogleFonts.ubuntuMono(fontSize: 32, color: Colors.grey.shade900),
                      )
                  )),
                  Expanded(flex: 5, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                ],
              ),
            ),
            Expanded(
              flex: 300,
              child: Padding(padding: const EdgeInsets.all(5),
                child: _wordsList.isNotEmpty ? GridView.builder(
                  itemCount: _wordsList.length,
                  itemBuilder: (context, index) {
                    return WordsListWidget(index: index, wordsData: _wordsList,);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisExtent: 60),
                ) : const Center(child: Text("Nothing to show...", style: TextStyle(fontSize: 30, color: Colors.black54),),),
              ),
            ),
          ],)
        ),
      ],),
    );
  }

  void fetchArticlesList() async{
    List? response = await Server.getAllArticles();
    if(response.isNotEmpty){
      articlesAllInfoList.clear();
      articlesList.clear();
      articlesList.add('');
      for(final artName in response){
        setState(() {
          articlesList.add(artName[1]);
          articlesAllInfoList = response;
        });
      }
    }
  }
}