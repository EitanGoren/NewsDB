import 'package:flutter/material.dart';
import 'package:news_db/widgets/create_words_group_widget.dart';
import 'package:news_db/widgets/enter_phrase_widget.dart';
import 'package:news_db/widgets/get_group_idx_widget.dart';
import 'package:news_db/widgets/load_article_widget.dart';
import 'package:news_db/widgets/show_words_widget.dart';
import 'package:news_db/widgets/statistics_widget.dart';
import '../widgets/database_operations_widget.dart';
import '../widgets/search_Article_widget.dart';
import '../widgets/search_words_widget.dart';

class SideMenuData{

  final destinations = const <NavigationRailDestination>[
    NavigationRailDestination(icon: Icon(Icons.dataset_linked_rounded), label: Text('Database')),
    NavigationRailDestination(icon: Icon(Icons.upload), label: Text('Upload Article')),
    NavigationRailDestination(icon: Icon(Icons.search_rounded), label: Text('Search Article')),
    NavigationRailDestination(icon: Icon(Icons.wordpress_rounded), label: Text('Show Words')),
    NavigationRailDestination(icon: Icon(Icons.search_sharp), label: Text('Search Words')),
    NavigationRailDestination(icon: Icon(Icons.group_rounded), label: Text('Words Group')),
    NavigationRailDestination(icon: Icon(Icons.plus_one_rounded), label: Text('Enter Phrase')),
    NavigationRailDestination(icon: Icon(Icons.get_app_rounded), label: Text('Get Group Index')),
    NavigationRailDestination(icon: Icon(Icons.query_stats_rounded), label: Text('Statistics')),
  ];

  final screens = <Widget>[
    const DatabaseOperationsWidget(),
    const LoadArticleWidget(),
    const SearchArticleWidget(),
    const ShowWordsWidget(),
    const SearchWordsWidget(),
    const CreateWordsGroupWidget(),
    const EnterPhraseWidget(),
    const GetGroupIdxWidget(),
    const StatisticsWidget(),
  ];
}