import 'package:flutter/material.dart';
import 'special_days.dart';
import 'add_special.dart';
import 'predefined_special_days.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gonul Al"),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.adb)),
              Tab(icon: Icon(Icons.android)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SpecialDays(),
            PredefinedSpecialDays(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddSpecialRoute()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
