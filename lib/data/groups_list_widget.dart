import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupsListWidget extends StatefulWidget {
  final int index;
  final List groupsData;

  const GroupsListWidget({super.key, required this.index, required this.groupsData});

  @override
  State<GroupsListWidget> createState() => _GroupsListWidgetState();
}

class _GroupsListWidgetState extends State<GroupsListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.groupsData.isNotEmpty ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: SizedBox(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Center(child: Text('${widget.groupsData[widget.index]}', style: GoogleFonts.ubuntuMono(fontSize: 35, color: Colors.black87))),
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(child: Text('${widget.groupsData[widget.index]}'),),
                            ),
                          );
                        },
                      );
                    },
                    child: Center(child: Text('${widget.groupsData[widget.index]}', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    // label: Text('Index', style: GoogleFonts.ubuntuMono(fontSize: 14, color: Colors.black54),),
                  ),
                ),
              ),
            ),
        ],),
      ),
    ): Spacer();
  }
}