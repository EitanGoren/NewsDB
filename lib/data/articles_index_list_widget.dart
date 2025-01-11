import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesIndexListWidget extends StatefulWidget {
  final int index;

  const ArticlesIndexListWidget({super.key, required this.index});

  @override
  State<ArticlesIndexListWidget> createState() => _ArticlesIndexListWidgetState();
}

class _ArticlesIndexListWidgetState extends State<ArticlesIndexListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Material(
        elevation: 12,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30),),
        color: Colors.grey.shade300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text('Article ${widget.index}', style: GoogleFonts.ubuntuMono(fontSize: 25, color: Colors.black54),),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Column(
                  spacing: 5,
                  children: [
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Total number of words:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                      Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of lines:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text('80', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),)
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Average chars in word:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                    Row(spacing: 15, children: [
                      Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                      Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                    ],),
                  ],
                ),
              ),
          ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 8, right: 6, top: 5),
                child: Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      flex:6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Center(child: Text('Article ${widget.index} words frequency list')),
                                  content: Column(
                                    spacing: 5,
                                    children: [
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('abc', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                        Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                      ],),
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('def', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                        Expanded(flex:8, child: Text('80', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),)
                                      ],),
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('ghi', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                        Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                      ],),
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('jkl', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                        Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                      ],),
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('mnopq', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                        Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                      ],),
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('rst', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                        Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                      ],),
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('uvwx', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                        Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                      ],),
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('y', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                        Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                      ],),
                                      Row(spacing: 15, children: [
                                        Expanded(flex:15, child: Text('zzz', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                        Expanded(flex:8, child: Text('80', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),)
                                      ],),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.list, size: 20, color: Colors.cyan,),
                          label: Text('Frequency list', style: GoogleFonts.ubuntuMono(fontSize: 16, color: Colors.black54),),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                    ),
                    Expanded(
                      flex:5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Center(child: Text('Article ${widget.index}')),
                                  content: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          spacing: 5,
                                          children: [
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Total number of words:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                              Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of lines:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('80', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),)
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Average chars in word:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          spacing: 5,
                                          children: [
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Total number of words:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                              Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of lines:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('80', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),)
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Average chars in word:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          spacing: 5,
                                          children: [
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Total number of words:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                              Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),)),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of lines:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('80', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),)
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Average chars in word:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('450', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of pages:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                            Row(spacing: 15, children: [
                                              Expanded(flex:15, child: Text('Number of chars:', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                              Expanded(flex:8, child: Text('2234', style: GoogleFonts.ubuntuMono(fontSize: 20, color: Colors.black54),),),
                                            ],),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.open_in_full, size: 20, color: Colors.cyan,),
                          label: Text('Full info', style: GoogleFonts.ubuntuMono(fontSize: 16, color: Colors.black54),),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],),
      ),
    );
  }
}