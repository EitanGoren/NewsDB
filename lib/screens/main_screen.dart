import 'package:flutter/material.dart';
import '../data/side_menu_data.dart';
import 'package:google_fonts/google_fonts.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final data = SideMenuData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Material(
                  borderOnForeground: true,
                  borderRadius: const BorderRadius.all(Radius.circular(18.0),),
                  elevation: 4,
                  color: Colors.transparent,
                  child: Center(child: Text('News DB',style: GoogleFonts.caveat(fontSize: 36,color: Colors.white),),),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: NavigationRail (
                    indicatorColor: Colors.transparent,
                    onDestinationSelected: (int index){
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    groupAlignment: 0.0,
                    backgroundColor: Colors.black,
                    selectedIndex: _selectedIndex,
                    destinations: data.destinations,
                    labelType: NavigationRailLabelType.all,
                    selectedIconTheme: const IconThemeData(color: Colors.blue, size: 30),
                    unselectedIconTheme: IconThemeData(color: Colors.grey.shade300, size: 30),
                    selectedLabelTextStyle: GoogleFonts.montserratAlternates(color: Colors.blue, fontSize: 14),
                    unselectedLabelTextStyle: GoogleFonts.montserratAlternates(color: Colors.grey.shade300, fontSize: 14),
                    elevation: 8,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: data.screens[_selectedIndex]
          ),
        ]
      )
    );
  }
}