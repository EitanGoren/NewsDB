import 'package:flutter/material.dart';

import '../backend/server.dart';
import '../data/articles_index_list_widget.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({super.key});

  @override
  State<StatisticsWidget> createState() => _StatisticsState();
}

class _StatisticsState extends State<StatisticsWidget> {
  late List<Map<String,dynamic>> statisticsList = [];

  @override
  void initState() {
    fetchStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: GridView.builder(
          itemCount: statisticsList.length,
          itemBuilder: (context, index) {
            return ArticlesIndexListWidget(index: index, statisticsList: statisticsList,);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        ),
      ),
    );
  }

  void fetchStatistics() async{
    List? response = await Server.getStatistics();
    if(response.isNotEmpty){
      statisticsList.clear();
    }
    for(dynamic info in response){
      double? parsedValue1 = double.tryParse(info["avg_chars_per_word"]); // Safely parse string to double
      double? parsedValue2 = double.tryParse(info["avg_words_per_line"]);

      if (parsedValue1 != null) {
        info["avg_chars_per_word"] = parsedValue1.toStringAsFixed(3);
      }
      if (parsedValue2 != null) {
        info["avg_words_per_line"] = parsedValue2.toStringAsFixed(3);
      }
      setState(() {
        statisticsList.add(info);
      });
    }
  }
}

