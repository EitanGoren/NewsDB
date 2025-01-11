import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:news_db/screens/main_screen.dart';


void main() async {
  runApp(const MyApp());
  await DesktopWindow.setWindowSize(Size(1500, 950));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News DB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}