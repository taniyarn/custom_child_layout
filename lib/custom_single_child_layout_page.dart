import 'dart:ui';

import 'package:flutter/material.dart';

class CustomSingleChildLayoutPage extends StatefulWidget {
  const CustomSingleChildLayoutPage({Key? key}) : super(key: key);

  @override
  State<CustomSingleChildLayoutPage> createState() =>
      _CustomSingleChildLayoutPageState();
}

class _CustomSingleChildLayoutPageState
    extends State<CustomSingleChildLayoutPage> {
  Offset? offset;
  int size = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Listener(
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          child: Container(
            color: theme.primaryColor.withOpacity(0.2),
            width: 300,
            height: 300,
            child: CustomSingleChildLayout(
              delegate: _MySingleChildLayoutDelegate(offset: offset),
              child: Container(
                color: theme.primaryColor,
                width: 50.0 * size,
                height: 50.0 * size,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (size < 6) {
                setState(() {
                  size++;
                });
              }
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              if (size > 0) {
                setState(() {
                  size--;
                });
              }
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() => offset = event.localPosition);
  }

  void _onPointerMove(PointerMoveEvent event) {
    setState(() => offset = event.localPosition);
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() => offset = null);
  }
}

class _MySingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  _MySingleChildLayoutDelegate({required this.offset});

  final Offset? offset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    if (offset == null) {
      return Offset(size.width / 2 - childSize.width / 2,
          size.height / 2 - childSize.height / 2);
    }

    final width = clampDouble(
        offset!.dx, childSize.width / 2, size.width - childSize.width / 2);
    final height = clampDouble(
        offset!.dy, childSize.height / 2, size.height - childSize.height / 2);

    return Offset(width - childSize.width / 2, height - childSize.height / 2);
  }

  @override
  bool shouldRelayout(covariant _MySingleChildLayoutDelegate oldDelegate) =>
      oldDelegate.offset != offset;
}
