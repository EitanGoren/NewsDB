import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Server {
  static final String baseUrl = 'http://127.0.0.1:5000';

  static Future<List> getAllWords() async {
    Uri allWords = Uri.parse('$baseUrl/all_words');
    final response = await http.get(allWords);
    List<dynamic> result = [];
    try {
      //converting it from json to key value pair
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      result = decoded['words'];
    }on Exception catch (e) {
      // Anything else that is an exception
      print('Unknown exception: $e');
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
    } finally{
      return result;
    }
  }

  static Future<List> getAllArticles() async {
    Uri allArticles = Uri.parse('$baseUrl/all_articles');
    final response = await http.get(allArticles);
    List<dynamic> result = [];
    try {
      //converting it from json to key value pair
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      result = decoded['data'];
    }on Exception catch (e) {
      // Anything else that is an exception
      print('Unknown exception: $e');
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
    } finally{
      return result;
    }
  }

  static Future<List> getAllPhrases() async {
    Uri allPhrases = Uri.parse('$baseUrl/all_phrases');
    final response = await http.get(allPhrases);
    List<dynamic> result = [];
    try {
      //converting it from json to key value pair
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      result = decoded['data'];
    }on Exception catch (e) {
      // Anything else that is an exception
      print('Unknown exception: $e');
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
    } finally{
      return result;
    }
  }

  static Future<List> getStatistics() async {
    Uri dbStatistics = Uri.parse('$baseUrl/db_statistics');
    final response = await http.get(dbStatistics);
    List<dynamic> result = [];
    try {
      //converting it from json to key value pair
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      result = decoded['data'];
    }on Exception catch (e) {
      // Anything else that is an exception
      print('Unknown exception: $e');
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
    } finally{
      return result;
    }
  }

  static Future<void> exportDbToXml() async {
    Uri exportDB = Uri.parse('$baseUrl/export_db_to_xml');
    final response = await http.get(exportDB);
    if (response.statusCode == 201 || response.statusCode == 200) {
      // Get the directory to save the file
      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath != null) {
        // Directory path selected
        print('Selected Directory: $directoryPath');
      } else {
        // User canceled the directory selection
        print('No directory selected.');
      }

      final filePath = '$directoryPath/popo.zip';

      // Write the file to the local storage
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print('File downloaded to: $filePath');
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      // return values;
    }
    else {
      // If the server did not return a 201 CREATED response,
      // return {'success': false, 'response': response.reasonPhrase};
      print('error');
    }
  }

  static Future<List> getAllGroups() async {
    Uri allArticles = Uri.parse('$baseUrl/all_groups');
    final response = await http.get(allArticles);
    List<dynamic> result = [];
    try {
      //converting it from json to key value pair
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      result = decoded['data'];
    }on Exception catch (e) {
      // Anything else that is an exception
      print('Unknown exception: $e');
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
    } finally{
      return result;
    }
  }

  static Future<dynamic> dropArticleByID(String artId) async {
    final response = await http.post(
        Uri.parse('$baseUrl/drop_article'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'article_id': artId,
        }),
        encoding: Encoding.getByName("utf-8")
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var result = await json.decode(json.encode(response.body));
      Map values = jsonDecode(result);
      return values;
    }
    else {
      return {'success': false, 'response': response.reasonPhrase};
    }
  }

  static Future<dynamic> getAllWordsByCriteria(Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/all_words_by_params'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'article_name': info['Article'],
      }),
      encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var result = await json.decode(json.encode(response.body));
      Map values = jsonDecode(result);
      return values;
    }
    else {
      // If the server did not return a 201 CREATED response,
      return {'success': false, 'response': response.reasonPhrase};
    }
  }

  static Future<dynamic> getAllGroupWordsByGroupName(String groupName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/all_group_words'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'group_name': groupName,
      }),
      encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var result = await json.decode(json.encode(response.body));
      Map values = jsonDecode(result);
      return values['data'];
    }
    else {
      // If the server did not return a 201 CREATED response,
      return {'success': false, 'response': response.reasonPhrase};
    }
  }

  static Future<Map?> insertNewArticle(String name, Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insert_article'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'article_name': name.toString(),
        'np_name': info['Newspaper Name'].toString(),
        'date': info['Date'],
        'author': info['Author'].toString(),
        'subject': info['Subject'].toString(),
        'data': info['Words'] as List<String>
      }),

      encoding: Encoding.getByName("utf-8")
    );

    var result = await json.decode(json.encode(response.body));
    print(result);
    Map values = jsonDecode(result);
    return values;
  }

  static Future<Map?> defineNewGroup(Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insert_group'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'group_name': info['Group Name'],
        'words': info['Words'],
        'words_ids': info['Words_ids'],
      }),

      encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var result = await json.decode(json.encode(response.body));
      print(result);
      Map values = jsonDecode(result);
      return values;
    }
    else {
      // If the server did not return a 201 CREATED response,
      return {'success': false, 'response': response.reasonPhrase};
    }
  }

  static Future<Map?> searchArticlesByFilters(Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search_article'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'article_name': info['Article Name'],
        'np_name': info['Newspaper Name'],
        'date': info['Date'],
        'page': info['Page'],
        'author': info['Author'],
        'subject': info['Subject'],
        'specific_words': info['Specific Words'],
      }),

      encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var result = await json.decode(json.encode(response.body));
      Map values = jsonDecode(result);
      return values;
    }
    else {
      // If the server did not return a 201 CREATED response,
      return {'success': false, 'response': response.reasonPhrase};
    }
  }

  static Future<Map?> checkWordExists(String wordName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check_word_exists'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'word_name': wordName,
      }),

      encoding: Encoding.getByName("utf-8")
    );

    var result = await json.decode(json.encode(response.body));
    Map values = jsonDecode(result);
    return values;
  }

  static Future<Map?> searchWordsByParams(Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search_words_by_params'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'article_name': info['Article'],
        'page': info['Page'],
        'line': info['Line'],
        'place_in_line': info['PlaceInLine'],
        'length': info['Length'],
      }),

      encoding: Encoding.getByName("utf-8")
    );

    var result = await json.decode(json.encode(response.body));
    Map values = jsonDecode(result);
    return values;
  }

  static Future<Map?> getWordsByArticleInfo(List<String> info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/words_by_article_info'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'article_id': info,
      }),
      encoding: Encoding.getByName("utf-8")
    );

    var result = await json.decode(json.encode(response.body));
    Map values = jsonDecode(result);
    return values;
  }

  static Future<Map?> getDistinctInfoByArticleName(String? articleName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_all_distinct_info_by_art_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'article_name': articleName,
      }),
      encoding: Encoding.getByName("utf-8")
    );

    var result = await json.decode(json.encode(response.body));
    Map values = jsonDecode(result);

    List<dynamic> dynamicPages = values['data']['pages'];
    List<dynamic> dynamicLines = values['data']['lines'];
    List<dynamic> dynamicLengths = values['data']['lengths'];
    List<dynamic> dynamicPlaceInLine = values['data']['place_in_line'];

    values['data']['pages'] = dynamicPages.map((item) => item.toString()).toList();
    values['data']['lines'] = dynamicLines.map((item) => item.toString()).toList();
    values['data']['lengths'] = dynamicLengths.map((item) => item.toString()).toList();
    values['data']['place_in_line'] = dynamicPlaceInLine.map((item) => item.toString()).toList();

    return values;
  }

  static Future<Map?> addWordsToGroup(Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_words_to_group'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'group_name': info['Group Name'],
        'words_ids': info['Words_ids'],
      }),
      encoding: Encoding.getByName("utf-8")
    );

    var result = await json.decode(json.encode(response.body));
    Map values = jsonDecode(result);
    return values;
  }

  static Future<void> pickAndSendZipFile() async {
    // Pick the file using the file_picker package
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['zip']);

    if (result != null) {
      // Get the selected file path
      String? filePath = result.files.single.path;

      if (filePath != null) {
        File file = File(filePath);

        // Prepare the request to send the file to the server
        try {
          // Create a multipart request
          var uri = Uri.parse('$baseUrl/upload_zip');
          var request = http.MultipartRequest('POST', uri);

          // Add the file to the request
          var fileBytes = await file.readAsBytes();
          var multipartFile = http.MultipartFile.fromBytes(
            'file', // This is the key the server expects
            fileBytes,
            filename: 'file.zip',
            // contentType: MediaType('application', 'zip'), // Correct MIME type for ZIP files
          );

          request.files.add(multipartFile);

          // Send the request to the server
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully');
          } else {
            print('Failed to upload file: ${response.statusCode}');
          }
        } catch (e) {
          print('Error: $e');
        }
      }
    } else {
      print('No file selected');
    }
  }

  static defineNewPhrase(Map<String, dynamic> info) async {
    final response = await http.post(
        Uri.parse('$baseUrl/insert_new_phrase'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'article_id': info['article_id'],
          'length': info['length'],
          'phrase': info['phrase'],
        }),

        encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var result = await json.decode(json.encode(response.body));
      print(result);
      Map values = jsonDecode(result);
      return values;
    }
    else {
      // If the server did not return a 201 CREATED response,
      return {'success': false, 'response': response.reasonPhrase};
    }
  }

  static Future<Map?> getPhraseInfo(Map<String, dynamic> info) async {
    final response = await http.post(
        Uri.parse('$baseUrl/get_phrase_info'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'article_id': info['article_id'],
          'phrase_id': info['phrase_id'],
          'length': info['phrase'].toString().trim().split(' ').length,
        }),

        encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var result = await json.decode(json.encode(response.body));
      print(result);
      Map values = jsonDecode(result);
      return values;
    }
    else {
      // If the server did not return a 201 CREATED response,
      return {'success': false, 'response': response.reasonPhrase};
    }
  }
}
