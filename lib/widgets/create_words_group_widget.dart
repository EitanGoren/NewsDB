import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/server.dart';
import '../data/group_words_list_widget.dart';
import '../data/groups_list_widget.dart';
import 'DropDownLabelWidgets/DropDownTextWidget.dart';
import 'EditTextWidgets/edit_text_widget.dart';

class CreateWordsGroupWidget extends StatefulWidget {
  const CreateWordsGroupWidget({super.key});

  @override
  State<CreateWordsGroupWidget> createState() => _CreateWordsGroupState();
}

class _CreateWordsGroupState extends State<CreateWordsGroupWidget> {
  List<String> groupsList = [];
  List<String> groupWordsList = [];
  List<String> allWordsList = [];
  String selectedGroupOption = 'new';
  String _selectedGroup = '';
  Set<String> selectedWordsList = {};
  Set<String> clickedWordsList = {};
  String selectedWordsString = '';
  bool showGroups = false;
  late Map<String,dynamic> _queryServerResponse = {'success': false, 'response': ''};
  final Map<String, dynamic> _newGroupInfo = {
    'Group Name': '',
    'Words': List<String>,
    'Words_ids': List<String>,
  };

  void _updateValue(List<String> values) {
    setState(() {
      _queryServerResponse = {'success': false, 'response': ''};
      if(values.length == 2) {
        if(values.first == 'Words'){
          _newGroupInfo[values.first] = (values.last).toString().split(',');
        }
        else {
          _newGroupInfo[values.first] = values.last;
        }
      }
    });
  }

  void _selectGroup(List<String> values) {
    setState(() {
      clickedWordsList.clear();
      selectedWordsList.clear();
      selectedWordsString = '';
      _queryServerResponse = {'success': false, 'response': ''};
      if(values.length == 2) {
        _selectedGroup = values.last;
      }
    });
  }

  void _chosenWords(List<String> values) {
    setState(() {
      if(values.length == 2) {
        if(values.first == 'Enter Words'){
          selectedWordsString = values.last;
        }
      }
    });
  }

  @override
  void initState() {
    fetchGroupsList();
    fetchAllWordsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Row(children: [
        Expanded(
          flex: 150,
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
                            selectedGroupOption = value.first;
                          });
                        },
                        selected: <String>{selectedGroupOption},
                        segments: <ButtonSegment<String>>[
                          ButtonSegment<String>(
                            value: 'new',
                            label: Text('Create new', style: GoogleFonts.yantramanav(fontSize: 20, color: Colors.black54),),
                          ),
                          ButtonSegment<String>(
                            value: 'existing',
                            label: Text('Add to existing', style: GoogleFonts.yantramanav(fontSize: 20, color: Colors.black54),),
                          ),
                        ],
                      ),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: SizedBox(
                  width: 400,
                  height: 350,
                  child: Padding(padding: const EdgeInsets.all(5),
                    child: Material(
                      elevation: 12,
                      borderRadius: BorderRadius.circular(25),
                      child: selectedGroupOption == "new" ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 17, bottom: 8, left: 15, right: 15),
                            child: EditTextWidget(
                              labelText: 'Group Name',
                              updateValue: _updateValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            child: EditTextWidget(
                              labelText: 'Words',
                              updateValue: _updateValue,
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_newGroupInfo['Group Name'] == ''){
                                    setState(() {
                                      _queryServerResponse['success'] = false;
                                      _queryServerResponse['response'] = "Missing group name.. Try Again";
                                    });
                                    return;
                                  }

                                  _newGroupInfo['Words'] = [];
                                  _newGroupInfo['Words'].addAll(clickedWordsList);
                                  if(_newGroupInfo['Words'].isNotEmpty){
                                    _newGroupInfo['Words_ids'] = [];
                                    for (final word in _newGroupInfo['Words']){
                                      if (word == '') continue;
                                      Map? response = await Server.checkWordExists(word);
                                      if(!response!['success']){
                                        setState(() {
                                          _queryServerResponse['success'] = false;
                                          _queryServerResponse['response'] = "The word $word is not in database!";
                                        });
                                      }
                                      else if(response['data'] != null){
                                        _newGroupInfo['Words_ids'].add(response['data'].toString());
                                      }
                                    }
                                  }

                                  Map? response = await Server.defineNewGroup(_newGroupInfo);
                                  setState(() {
                                    _queryServerResponse['success'] = response!['success'];
                                    _queryServerResponse['response'] = response['response'].toString();
                                    if(_queryServerResponse['success']){
                                      fetchGroupsList();
                                      fetchGroupsWordsList(_newGroupInfo['Group Name']);
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
                                  child:Text('Create Group',
                                    style: TextStyle(fontSize: 25, color: Colors.white,),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ) : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: DropDownTextWidget(
                                  labelText: 'Groups',
                                  updateValue: _selectGroup,
                                  dataList: groupsList,
                                ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            child: EditTextWidget(
                              labelText: 'Enter Words',
                              updateValue: _chosenWords,
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if(clickedWordsList.isEmpty && selectedWordsString.isEmpty){
                                      setState(() {
                                        _queryServerResponse['success'] = false;
                                        _queryServerResponse['response'] = "No words chosen..";
                                      });
                                      return;
                                    }

                                    selectedWordsList.clear();
                                    selectedWordsList.addAll(clickedWordsList);
                                    List<String> l = selectedWordsString.split(',');
                                    l.remove('');
                                    selectedWordsList.addAll(l);
                                    _newGroupInfo['Words_ids'] = [];
                                    _newGroupInfo['Group Name'] = _selectedGroup;
                                    for (final word in selectedWordsList){
                                      if (word == '' || word == ' ') continue;
                                      Map? response = await Server.checkWordExists(word);
                                      if(!response!['success']){
                                        setState(() {
                                          _queryServerResponse['success'] = false;
                                          _queryServerResponse['response'] = "The word $word is not in database!";
                                        });
                                      }
                                      else if(response['data'] != null){
                                        _newGroupInfo['Words_ids'].add(response['data'].toString());
                                      }
                                    }

                                    Map? response = await Server.addWordsToGroup(_newGroupInfo);
                                    setState(() {
                                      _queryServerResponse['success'] = response!['success'];
                                      _queryServerResponse['response'] = response['response'].toString();
                                      if(_queryServerResponse['success']){
                                        fetchGroupsWordsList(_selectedGroup);
                                      }
                                    });

                                    setState(() {
                                      fetchAllWordsList();
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
                                    child:Text('Add to Group',
                                      style: TextStyle(fontSize: 25, color: Colors.white,),),
                                  ),
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
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Center(
                      child: Text(_queryServerResponse['response'], style: TextStyle(fontSize: 20, color:
                      _queryServerResponse['success'] == true ? Colors.green.shade400 : Colors.red.shade400
                      ),)
                  )
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(color: Colors.grey.shade50, child: null),
        ),
        Expanded(
          flex: 250,
          child: Column(
            children: [
              Expanded(
                flex: 20,
                child: Row(
                  children: [
                    Expanded(flex: 2, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                    Expanded(flex: 4, child: Center(child: Text('All Words', style: GoogleFonts.ubuntuMono(fontSize: 32, color: Colors.grey.shade900),))),
                    Expanded(flex: 10, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                  ],
                ),
              ),
              Expanded(
                flex: 150,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 8, right: 8),
                  child: allWordsList.isNotEmpty ? GridView.builder(
                      itemCount: allWordsList.length,
                      itemBuilder: (context, index) {
                        dynamic temp = GroupWordsListWidget(index: index, wordsData: allWordsList, clickedWordsList: clickedWordsList);
                        return temp;
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                    ) : const Center(child: Text("Nothing to show...", style: TextStyle(fontSize: 20, color: Colors.black54),),),
                ),
              ),
              Expanded(
                flex: 20,
                child: Row(
                  children: [
                    Expanded(flex: 2, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                    Expanded(flex: 4, child: Center(child: Text('All Groups', style: GoogleFonts.ubuntuMono(fontSize: 32, color: Colors.grey.shade900),))),
                    Expanded(flex: 10, child: SizedBox(child: Container(height: 3, color: Colors.grey.shade50),),),
                  ],
                ),
              ),
              Expanded(
                flex: 70,
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: groupsList.isNotEmpty ? ListView.builder(
                            itemCount: groupsList.length,
                            itemBuilder: (context, index) {
                              return GroupsListWidget(index: index, groupsData: groupsList);
                            },
                            padding: const EdgeInsets.all(14.0),
                          ) : const Center(child: Text("Nothing to show...", style: TextStyle(fontSize: 30, color: Colors.black54),),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }

  void fetchGroupsList() async{
    List? response = await Server.getAllGroups();
    if(response.isNotEmpty){
      groupsList.clear();
      for(final groupName in response){
        setState(() {
          groupsList.add(groupName[1]);
        });
      }
    }
  }

  void fetchGroupsWordsList(String groupName) async{
    List? response = await Server.getAllGroupWordsByGroupName(groupName);
    if(response!.isNotEmpty){
      groupWordsList.clear();
      for(final word in response){
        setState(() {
          groupWordsList.add(word);
        });
      }
    }
  }

  void fetchAllWordsList() async{
    List? response = await Server.getAllWords();
    if(response.isNotEmpty){
      allWordsList.clear();
      for(final wordName in response){
        setState(() {
          allWordsList.add(wordName[0]);
        });
      }
    }
  }
}
