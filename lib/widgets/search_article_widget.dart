
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_db/data/articles_list_widget.dart';

import '../backend/server.dart';
import 'EditTextWidgets/edit_text_widget.dart';

class SearchArticleWidget extends StatefulWidget {
  const SearchArticleWidget({super.key});

  @override
  State<SearchArticleWidget> createState() => _SearchArticleState();
}

class _SearchArticleState extends State<SearchArticleWidget> {
  late Map<String,dynamic> _query_server_response = {'success': false, 'response': ''};
  late List _articlesList = [];
  final Map<String, dynamic> _searchArticleInfo = {
    'Article Name': '',
    'Newspaper Name': '',
    'Date': '',
    'Page': '',
    'Author': '',
    'Subject': '',
    'Specific Words': '',
  };

  void _updateValue(List<String> values) {
    setState(() {
      _query_server_response = {'success': false, 'response': ''};
      if(values.length == 2) {
        _searchArticleInfo[values[0]] = values[1];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
                height: 670,
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
                            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                            child: EditTextWidget(
                              labelText: 'Article Name',
                              updateValue: _updateValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: EditTextWidget(
                              labelText: 'Newspaper Name',
                              updateValue: _updateValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: EditTextWidget(
                              labelText: 'Date',
                              updateValue: _updateValue,
                            ),),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: EditTextWidget(
                              labelText: 'Author',
                              updateValue: _updateValue,
                            ),),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: EditTextWidget(
                              labelText: 'Subject',
                              updateValue: _updateValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: EditTextWidget(
                              labelText: 'Specific Words',
                              updateValue: _updateValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20,),
                            child: ElevatedButton(
                              onPressed: () async {
                                int counter = 0;
                                for (final param in _searchArticleInfo.values){
                                  if (param == ''){
                                    counter++;
                                  }
                                }
                                if(counter == _searchArticleInfo.length)
                                {
                                  setState(() {
                                    _articlesList.clear();
                                    _query_server_response['success'] = false;
                                    _query_server_response['response'] = "All boxes are empty,\nFill at least one and try again.";
                                  });
                                  return;
                                }
                                // At least one param is set.
                                Map? response = await Server.searchArticlesByFilters(_searchArticleInfo);
                                setState(() {
                                  _articlesList.clear();
                                  _query_server_response['success'] = response!['success'];
                                  _query_server_response['response'] = response['response'].toString();
                                  if(response['success']){
                                    _articlesList = response['data'];
                                  }
                                });
                                print(_articlesList);
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
                                child:Text('Search Article',
                                  style: TextStyle(fontSize: 25, color: Colors.white,),),
                              ),
                            ),
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
        ),),
        Expanded(
          flex: 1,
          child: SizedBox(child: Container(color: Colors.grey.shade50, child: null),),
        ),
        Expanded(
          flex: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(flex: 2, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                    Expanded(flex: 6, child: Center(child: Text('All Articles', style: GoogleFonts.ubuntuMono(fontSize: 32, color: Colors.grey.shade900),))),
                    Expanded(flex: 10, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: _articlesList.isNotEmpty ? GridView.builder(
                    itemCount: _articlesList.length,
                    itemBuilder: (context, index) {
                      return ArticlesListWidget(index: index, articlesData: _articlesList,);
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  ) : const Center(child: Text("Nothing to show...", style: TextStyle(fontSize: 30, color: Colors.black54),),),
                ),
              ),
          ],),
        ),
    ],),
    );
  }
}
