import 'package:diary_fit/tads/client.dart';
import 'package:flutter/material.dart';

abstract class HomeScreenContentInterface extends StatefulWidget {
  const HomeScreenContentInterface({super.key});

  ClientType get clientType;
  String get title;
  Map<NavigationRailDestination, Widget> get contents;

  @override
  State<HomeScreenContentInterface> createState() =>
      _HomeScreenContentInterfaceState();
}

class _HomeScreenContentInterfaceState
    extends State<HomeScreenContentInterface> {
  final _groupAlignment = -1.0;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        NavigationRail(
          selectedIndex: _selectedIndex,
          groupAlignment: _groupAlignment,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: widget.contents.keys.toList(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        widget.contents.values.elementAt(_selectedIndex),
      ],
    );
  }
}
