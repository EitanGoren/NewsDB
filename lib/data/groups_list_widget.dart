import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/server.dart';

class GroupsListWidget extends StatefulWidget {
  final int index;
  final List groupsData;

  const GroupsListWidget({super.key, required this.index, required this.groupsData});

  @override
  State<GroupsListWidget> createState() => _GroupsListWidgetState();
}

class _GroupsListWidgetState extends State<GroupsListWidget> {
  late List groupWordsList = [];

  @override
  void initState() {
    fetchGroupsWordsList(widget.groupsData[widget.index]);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return widget.groupsData.isNotEmpty ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: TextButton(
              onPressed: () {
                setState(() {
                  fetchGroupsWordsList(widget.groupsData[widget.index]);
                });
                showCustomPopup(context);
              },
              child: Center(child: Text(widget.groupsData[widget.index], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
              // label: Text('Index', style: GoogleFonts.ubuntuMono(fontSize: 14, color: Colors.black54),),
            ),
          ),
        ),
      ),
    ): Spacer();
  }
  void showCustomPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            height: 300,
            width: 350,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 250,
                    child: groupWordsList.isNotEmpty ? ListView.builder(
                      itemCount: groupWordsList.length,
                      itemBuilder: (context, index) {
                        return Text(groupWordsList[index], style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),);
                      },
                    ) : Text("Nothing to show...", style: TextStyle(fontSize: 16, color: Colors.black54),),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}