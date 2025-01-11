import 'package:flutter/material.dart';
import 'package:news_db/backend/server.dart';

import '../backend/os_operations.dart';
import 'DropDownLabelWidgets/DropDownTextWidget.dart';
import 'EditTextWidgets/edit_text_widget.dart';

class LoadArticleWidget extends StatefulWidget {
  const LoadArticleWidget({super.key});

  @override
  State<LoadArticleWidget> createState() => _LoadArticleState();
}

class _LoadArticleState extends State<LoadArticleWidget> {
  Set<String> articlesList = {};
  Map<String, String> articlesIDList = {};
  late Map<String,dynamic> _query_server_response = {'success': false, 'response': ''};
  final Map<String, dynamic> _newArticleInfo = {
    'Newspaper Name': '',
    'Date': '',
    'Author': '',
    'Subject': '',
    'Words': List<String>
  };
  late String _dropArticleInfo;

  void _updateValue(List<String> values) {
    setState(() {
      _query_server_response = {'success': false, 'response': ''};
      if(values.length == 2) {
        _newArticleInfo[values.first] = values.last;
      }
    });
  }

  void _chosenArtToDrop(List<String> artId) async {
    setState(() {
      _query_server_response = {'success': false, 'response': ''};
      if(artId.length == 2) {
        _dropArticleInfo = articlesIDList[artId.last]!;
      }
    });
  }

  @override
  void initState() {
    fetchArticlesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 110,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 490,
                    height: 570,
                    child: Material(
                      elevation: 15.5,
                      borderRadius: BorderRadius.circular(25),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              EditTextWidget(
                                  labelText: 'Newspaper Name',
                                  updateValue: _updateValue,
                              ),
                              EditTextWidget(
                                labelText: 'Date',
                                updateValue: _updateValue,
                              ),
                              EditTextWidget(
                                labelText: 'Author',
                                updateValue: _updateValue,
                              ),
                              EditTextWidget(
                                labelText: 'Subject',
                                updateValue: _updateValue,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    for (final val in _newArticleInfo.values){
                                      if (val == ''){
                                        setState(() {
                                          _query_server_response['success'] = false;
                                          _query_server_response['response'] = "Missing some data.. Try Again";
                                        });
                                        return;
                                      }
                                    }
                                    // All params are filled.
                                    List<String> fileLines = await readArticleFile();
                                    if (fileLines.isEmpty){
                                      setState(() {
                                        _query_server_response['success'] = false;
                                        _query_server_response['response'] = "Article is empty.. Try Again";
                                      });
                                      return;
                                    }

                                    _newArticleInfo['Words'] = fileLines.sublist(1, fileLines.length-1);
                                    Map? response = await Server.insertNewArticle(fileLines.first, _newArticleInfo);
                                    setState(() {
                                      _query_server_response['success'] = response!['success'];
                                      _query_server_response['response'] = response['response'].toString();
                                      fetchArticlesList();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      overlayColor: Colors.blue.shade50,
                                      elevation: 15,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      textStyle: const TextStyle(fontSize: 22, color: Colors.black54,),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child:Text('Upload Article',
                                    style: TextStyle(fontSize: 22, color: Colors.white,),),
                                  ),
                                ),
                              ),

                              // Drop Table
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                      child: DropDownTextWidget(
                                        labelText: 'Article',
                                        updateValue: _chosenArtToDrop,
                                        dataList: articlesList,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Map? response = await Server.dropArticleByID(_dropArticleInfo);
                                          setState(() {
                                            _query_server_response['success'] = response!['success'];
                                            _query_server_response['response'] = response['response'].toString();
                                            fetchArticlesList();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade600,
                                          overlayColor: Colors.white,
                                          elevation: 15,
                                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                                          textStyle: const TextStyle(fontSize: 15, color: Colors.black54,),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child:Text('Drop Article', style: TextStyle(fontSize: 15, color: Colors.white,),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                      child: Center(
                          child: Text(_query_server_response['response'], style: TextStyle(fontSize: 20, color:
                          _query_server_response['success'] == true ? Colors.green.shade400 : Colors.red.shade400
                          ),)
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchArticlesList() async{
    List? response = await Server.getAllArticles();
    if(response.isNotEmpty){
      articlesList.clear();
      articlesIDList.clear();
      for(final artName in response){
        setState(() {
          articlesList.add(artName[1]);
          articlesIDList[artName[1]] = artName[0];
        });
      }
    }
  }
}
