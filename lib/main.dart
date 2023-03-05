import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
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
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => TabBarView(
            controller: _tabController,
            children: const [
              MultiPage(),
              SinglePage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) {
          if (_tabController.index != index) {
            _tabController.index = index;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}

class MultiPage extends StatelessWidget {
  const MultiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: CustomMultiChildLayout(
            delegate: _MyLayoutDelegate(),
            children: [
              LayoutId(id: 0, child: Text('Widget 0')),
              LayoutId(id: 1, child: Text('Widget 1')),
              LayoutId(id: 2, child: Text('Widget 2')),
              LayoutId(id: 3, child: Text('Widget 3')),
              LayoutId(id: 4, child: Text('Widget 4')),
              LayoutId(id: 5, child: Text('Widget 5')),
              LayoutId(id: 6, child: Text('Widget 6')),
            ],
          ),
        ),
      ),
    );
  }
}

class SinglePage extends StatelessWidget {
  const SinglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            color: Colors.red.withOpacity(0.2),
            width: 300,
            height: 300,
            child: CustomSingleChildLayout(
              delegate: _MySingleChildLayoutDelegate(),
              child: Text('Widget 0'),
            )),
      ),
    );
  }
}

class _MyLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    int maxIndex = 0;
    while (true) {
      if (hasChild(maxIndex)) {
        maxIndex++;
        continue;
      }
      maxIndex--;
      break;
    }
    int index = 0;
    while (hasChild(index)) {
      final childSize = layoutChild(
        index,
        BoxConstraints.loose(size),
      );

      positionChild(
        index,
        Offset(
          (size.width - childSize.width) * index / maxIndex,
          (size.height - childSize.height) * index / maxIndex,
        ),
      );

      index++;
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    return true;
  }
}

class _MySingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset((size.width - childSize.width) / 2,
        (size.height - childSize.height) / 2);
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}
