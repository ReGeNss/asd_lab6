import 'package:flutter/material.dart';
import 'package:lab3/graph.dart';
import 'package:lab3/graph_analyzers/directed_graph_analyzer.dart';
import 'package:lab3/graph_analyzers/graph_analyzer.dart';
import 'package:lab3/graph_analyzers/undirected_graph_analyzer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GraphViewWidget(),
        ),
      ),
    );
  }
}

class GraphViewWidget extends StatefulWidget {
  const GraphViewWidget({
    super.key,
  });


  @override
  State<GraphViewWidget> createState() => _GraphViewWidgetState();
}

class _GraphViewWidgetState extends State<GraphViewWidget> {
  bool isDirected = true;
  late Graph graph;

  @override
  void initState() {
    graph = Graph.generate(isDirected, 550);
    final a = DirectedGraphAnalyzer(graph.adjacencyMatrix).getCondensedGraph();
    graph = Graph.directedFromAdjacencyMatrix(a, 550);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GraphAnalyzer analyzer = isDirected
        ? DirectedGraphAnalyzer(graph.adjacencyMatrix)
        : UndirectedGraphAnalyzer(graph.adjacencyMatrix);
    print(analyzer.getGraphInfo());
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 70,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdjacencyMatrixWidget(adjacencyMatrix: graph.adjacencyMatrix),
            SizedBox(width: 100),
            graph.graphWidget,
          ],
        ),
        FilledButton(
          onPressed: () {
            setState(() {
              isDirected = !isDirected;
              graph = Graph.generate(isDirected, 550);
            });
          },
          child: Text(isDirected ? "show undirected" : "show directed"),
        ),
      ],
    );
  }
}

class AdjacencyMatrixWidget extends StatelessWidget {
  const AdjacencyMatrixWidget({super.key, required this.adjacencyMatrix});

  final List<List<int>> adjacencyMatrix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: adjacencyMatrix.map((row) => Row(
          spacing: 10,
          children: row.map((cell) => Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            child: Text(
              cell.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )).toList(),
        )).toList(),
      ),
    );
  }
}