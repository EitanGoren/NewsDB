import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownTextWidget extends StatelessWidget {
  final String labelText;
  final ValueChanged<List<String>> updateValue;
  final List<String> dataList;

  const DropDownTextWidget({super.key, required this.labelText, required this.updateValue, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DropdownMenu<String>(
        initialSelection: labelText,
        onSelected: (String? value) {
          updateValue(<String>[labelText, value!]);
        },
        hintText: labelText,
        expandedInsets: const EdgeInsets.all(0),
        textStyle: GoogleFonts.montserrat(fontSize: 18,),
        dropdownMenuEntries: dataList.map<DropdownMenuEntry<String>>((dynamic value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      )
    ],);
  }
}

