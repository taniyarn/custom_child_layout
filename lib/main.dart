import 'package:flutter/material.dart';

import 'custom_multi_child_layout_page.dart';
import 'custom_single_child_layout_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MyHomePage(title: 'Custom Layout');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  MaterialColor primarySwatch = Colors.blue;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          primarySwatch = _tabController.index == 0 ? Colors.blue : Colors.red;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Multi'),
              Tab(text: 'Single'),
            ],
          ),
        ),
        body: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                CustomMultiChildLayoutPage(),
                CustomSingleChildLayoutPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
