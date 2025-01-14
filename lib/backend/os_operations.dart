import 'dart:core';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:news_db/backend/server.dart';
import 'package:path_provider/path_provider.dart';


Future<List<String>> readArticleFile() async {

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['txt'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    print(file);
    List<String> fileYeah = await file.readAsLines();
    fileYeah.insert(0, result.names.first!);
    return fileYeah;
  }
  else {
    // User canceled the picker
    print('Canceled!!');
  }
  return [];
}

Future<void> writeWordsToFile(String articleName, String fileName) async {
  String article = await getArticleContentByArticleName(articleName);

  // Get the directory to save the file
  String? directoryPath = await FilePicker.platform.getDirectoryPath();
  final filePath = '$directoryPath/$fileName';

  // Write the content to the file
  final file = File(filePath);
  await file.writeAsString(article);

  print("File written to: $filePath");
}

Future<String> getArticleContentByArticleName(String articleName) async{
  final Map<String, dynamic> _articleName = {
    'Article': articleName
  };
  final res = await Server.getAllWordsByCriteria(_articleName);
  List<Map<String, dynamic>> wordsInfo = <Map<String, dynamic>>[];
  for(var info in res['data']){
    Map<String, dynamic> wordInfo = <String, dynamic>{};
    wordInfo['word'] = info[0];
    wordInfo['page'] = info[2];
    wordInfo['line'] = info[3];
    wordInfo['place'] = info[4];
    wordsInfo.add(wordInfo);
  }

  // Sort the list of words by page, line, and position
  wordsInfo.sort((a, b) {
    int pageComparison = a['page'] - b['page'];
    if (pageComparison != 0) return pageComparison;

    int lineComparison = a['line'] - b['line'];
    if (lineComparison != 0) return lineComparison;

    return a['place'] - b['place'];
  });

  // Organize words by page and line
  Map<int, Map<int, List<String>>> organizedWords = {};

  for (var wordData in wordsInfo) {
    int page = wordData['page'];
    int line = wordData['line'];
    String word = wordData['word'];

    organizedWords.putIfAbsent(page, () => {});
    organizedWords[page]!.putIfAbsent(line, () => []);
    organizedWords[page]![line]!.add(word);
  }

  // Build the content for the file
  StringBuffer fileContent = StringBuffer();
  organizedWords.forEach((page, lines) {
    lines.forEach((line, wordsInLine) {
      fileContent.writeln(wordsInLine.join(' '));
    });
    fileContent.writeln(); // Add a blank line between pages
  });

  return fileContent.toString();
}

List<String> splitByExactWord(String text, String word) {
  // Create a regular expression to match the exact word
  RegExp regex = RegExp(r'\b' + RegExp.escape(word) + r'\b');

  // Split the string by the exact word
  return text.split(regex);
}


