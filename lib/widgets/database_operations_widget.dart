import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_db/backend/server.dart';


class DatabaseOperationsWidget extends StatefulWidget {
  const DatabaseOperationsWidget({super.key});

  @override
  State<DatabaseOperationsWidget> createState() => _DatabaseOperationsState();
}

class _DatabaseOperationsState extends State<DatabaseOperationsWidget> {

  late final Map<String,dynamic> _query_server_response = {'success': false, 'response': ''};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 70,
                width: 420,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                       await Server.exportDbToXml();
                       // setState(() {
                       //   _query_server_response['success'] = response!['success'];
                       //   _query_server_response['response'] = response['response'].toString();
                       // });
                    },
                    icon: const Icon(Icons.download, size: 30, color: Colors.blue,),
                    label: Text('Export Database (.xml)', style: GoogleFonts.ubuntuMono(fontSize: 24, color: Colors.black45),),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                width: 420,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Server.pickAndSendZipFile();
                    },
                    icon: const Icon(Icons.upload, size: 30, color: Colors.blue,),
                    label: Text('Import Database (.xml)', style: GoogleFonts.ubuntuMono(fontSize: 24, color: Colors.black45),),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ),
            ],
            ),
            Text(_query_server_response['response'], style: TextStyle(fontSize: 20, color:
            _query_server_response['success'] == true ? Colors.green.shade400 : Colors.red.shade400
            ),),
          ],
        ),
      ),
    );
  }
}
