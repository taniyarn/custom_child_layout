import 'package:flutter/material.dart';

class CustomMultiChildLayoutPage extends StatefulWidget {
  const CustomMultiChildLayoutPage({Key? key}) : super(key: key);

  @override
  State<CustomMultiChildLayoutPage> createState() =>
      _CustomMultiChildLayoutPageState();
}

class _CustomMultiChildLayoutPageState
    extends State<CustomMultiChildLayoutPage> {
  int count = 3;
  bool reverse = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Container(
          color: theme.primaryColor.withOpacity(0.2),
          width: 300,
          height: 300,
          child: CustomMultiChildLayout(
            delegate: _MyLayoutDelegate(reverse: reverse),
            children: [
              for (int i = 0; i < count; i++)
                LayoutId(
                  id: i,
                  child: Container(
                    color: theme.primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                reverse = !reverse;
              });
            },
            child: const Icon(Icons.swap_horiz),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                count++;
              });
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              if (count > 0) {
                setState(() {
                  count--;
                });
              }
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class _MyLayoutDelegate extends MultiChildLayoutDelegate {
  _MyLayoutDelegate({required this.reverse});
  final bool reverse;

  @override
  void performLayout(Size size) {
    int index = 0;
    while (hasChild(index)) {
      index++;
    }
    final childrenNum = index;

    index = 0;
    double sumSize = 0;
    while (hasChild(index)) {
      final childSize = layoutChild(
        index,
        BoxConstraints.tight(
            Size(size.width / childrenNum, size.height / childrenNum)),
      );
      assert(childSize.width == childSize.height);

      positionChild(
        index,
        Offset(reverse ? size.width - sumSize - childSize.width : sumSize,
            sumSize),
      );
      sumSize += childSize.width;
      index++;
    }
  }

  @override
  bool shouldRelayout(covariant _MyLayoutDelegate oldDelegate) =>
      oldDelegate.reverse != reverse;
}
