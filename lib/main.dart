import 'package:flutter/material.dart';
import 'package:lab3/graph.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Graph graph = Graph.generate();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: graph.graphWidget,
        ),
      ),
    );
  }
}
