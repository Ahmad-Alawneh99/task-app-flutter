import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final List<Widget> children;
  final double maxWidth;
  final double maxHeight;
  final bool addMargins;

  const Box({
    super.key,
    required this.children,
    this.maxWidth = 600,
    this.maxHeight = double.infinity,
    this.addMargins = true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
      padding: const EdgeInsets.all(16),
      margin: addMargins ? const EdgeInsets.fromLTRB(16, 96, 16, 16) : null,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 0),
        ),
      ],
      ),
      child: Center(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}