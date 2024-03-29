import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class MyNavigationBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MyNavigationBar({super.key, required this.navigationShell});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  /// method for handling navigation branches
  ///
  void changeBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  int selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 233, 232, 232),
      selectedItemColor: const Color.fromARGB(255, 170, 167, 167),
      // selectedItemColor: const Color.fromARGB(255, 243, 67, 67),
      unselectedItemColor: const Color.fromARGB(255, 170, 167, 167),
      selectedLabelStyle:
          const TextStyle(color: Color.fromARGB(255, 190, 186, 186)),
      currentIndex: selectedIndex,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.border_color_outlined), label: 'Surveys'),
        BottomNavigationBarItem(
            icon: Icon(Icons.assistant), label: 'Suggestions'),
        BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive_sharp), label: 'Advice'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded), label: 'Profile')
      ],
      onTap: (int newIndex) {
        changeBranch(newIndex);
        setState(() {
          selectedIndex = newIndex;
        });
      },
    );
  }
}
