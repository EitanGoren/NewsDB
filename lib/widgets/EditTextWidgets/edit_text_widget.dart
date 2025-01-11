import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTextWidget extends StatelessWidget {
  final String labelText;
  final ValueChanged<List<String>> updateValue;

  const EditTextWidget({super.key, required this.labelText, required this.updateValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: TextFormField(
          onChanged: (String value) {
            updateValue([labelText, value]);
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
            labelStyle: GoogleFonts.montserrat(fontSize: 20,),
          ),
        ),
    );
  }
}

