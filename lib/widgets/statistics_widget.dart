import 'package:flutter/material.dart';

import '../data/articles_index_list_widget.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({super.key});

  @override
  State<StatisticsWidget> createState() => _StatisticsState();
}

class _StatisticsState extends State<StatisticsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: GridView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return ArticlesIndexListWidget(index: index);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        ),
      ),
    );
  }
}
