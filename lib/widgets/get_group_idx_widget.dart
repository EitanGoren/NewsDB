import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/server.dart';
import '../data/group_words_only_list_widget.dart';
import 'DropDownLabelWidgets/DropDownTextWidget.dart';

class GetGroupIdxWidget extends StatefulWidget {
  const GetGroupIdxWidget({super.key});

  @override
  State<GetGroupIdxWidget> createState() => _GetGroupIdxState();
}

class _GetGroupIdxState extends State<GetGroupIdxWidget> {
  List<String> groupsList = [];
  List<String> groupWordsList = [];
  Map<String, String> groupsIDList = {};
  String _selectedGroup = '';
  late Map<String,dynamic> _queryServerResponse = {'success': false, 'response': ''};

  void _selectGroup(List<String> values) {
    setState(() {
      _queryServerResponse = {'success': false, 'response': ''};
      if(values.length == 2) {
        _selectedGroup = values.last;
      }
    });
  }

  @override
  void initState() {
    fetchGroupsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Expanded(
          flex: 200,
          child: Center(
            child: SizedBox(
              width: 450,
              height: 320,
              child: Padding(padding: const EdgeInsets.all(5),
                child: Material(
                  elevation: 15.5,
                  borderRadius: BorderRadius.circular(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: DropDownTextWidget(
                                        labelText: 'Groups',
                                        updateValue: _selectGroup,
                                        dataList: groupsList.toSet(),
                                      ),
                                    ),
                                  ),
                                ],)
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    fetchGroupsWordsList(_selectedGroup);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    overlayColor: Colors.blue.shade50,
                                    elevation: 15,
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    textStyle: const TextStyle(fontSize: 25, color: Colors.black54,),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child:Text('Fetch Data', style: TextStyle(fontSize: 24, color: Colors.white,),),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.download, size: 20, color: Colors.blue,),
                                          label: Text('Download group Index', style: GoogleFonts.ubuntuMono(fontSize: 16, color: Colors.black54),),
                                          iconAlignment: IconAlignment.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
          flex: 18,
          child: Row(
            children: [
              Expanded(flex: 2, child: SizedBox(child: Container(height: 2, color: Colors.grey.shade50),),),
              Expanded(flex: 4, child: Center(child: Text('Words in $_selectedGroup', style: GoogleFonts.ubuntuMono(fontSize: 32, color: Colors.black87),))),
              Expanded(flex: 10, child: SizedBox(child: Container(height: 2, color: Colors.grey.shade50),),),
            ],
          ),
        ),
        Expanded(
          flex: 240,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: groupsList.isNotEmpty ? GridView.builder(
              itemCount: groupWordsList.length,
              itemBuilder: (context, index) {
                return GroupWordsOnlyListWidget(index: index, wordsData:  groupWordsList,);
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
            ) : const Center(child: Text("Nothing to show...", style: TextStyle(fontSize: 30, color: Colors.black54),),),
          )
        ),
      ],),
    );
  }

  void fetchGroupsList() async{
    List? response = await Server.getAllGroups();
    if(response.isNotEmpty){
      groupsList.clear();
      groupsIDList.clear();
      for(final groupName in response){
        setState(() {
          groupsList.add(groupName[1]);
          groupsIDList[groupName[1]] = groupName[0];
        });
      }
    }
  }

  void fetchGroupsWordsList(String groupName) async{
    List? response = await Server.getAllGroupWordsByGroupId(groupName);
    if(response!.isNotEmpty){
      groupWordsList.clear();
      for(final word in response){
        setState(() {
          groupWordsList.add(word);
        });
      }
    }
  }
}
