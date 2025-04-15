import 'package:flutter/material.dart';
import 'package:lab3/graph.dart';
import 'package:lab3/graph_painters/directed_graph_painter.dart';
import 'package:lab3/graph_painters/undirected_graph_panter.dart';
import 'package:lab3/graph_traversal/bfs_traversal.dart';
import 'package:lab3/graph_traversal/dfs_traversal.dart';
import 'package:lab3/graph_traversal/traversal.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white54,
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
  Traversal? traversal;

  @override
  void initState() {
    graph = Graph.generate(isDirected, 550);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            isDirected && traversal != null 
            ? DirectedGraphWidget(
                adjacencyMatrix: graph.adjacencyMatrix,
                size: 550,
                vertexInfo: traversal!.vertexInfo,
              )
            : isDirected 
              ? DirectedGraphWidget(
                adjacencyMatrix: graph.adjacencyMatrix,
                size: 550,
              )
            : UnDirectedGraphWidget(
                adjacencyMatrix: graph.adjacencyMatrix,
                size: 550,
              ),
          ],
        ),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                setState(() {
                  isDirected = !isDirected;
                  graph = Graph.generate(isDirected, 400);
                });
              },
              child: Text(isDirected ? "show undirected" : "show directed"),
            ),
            FilledButton(
              onPressed: (){
                setState(() {
                  if(traversal != null && traversal is BfsTraversal){
                    traversal?.traversalStep();
                    return;
                  }else{
                    traversal = BfsTraversal(graph.adjacencyMatrix);
                    traversal?.startTraversal();
                  }
                });
              },
              child: const Text("BFS"),
            ),
            FilledButton(
              onPressed: (){
                setState(() {
                  if(traversal != null && traversal is DfsTraversal){
                    traversal?.traversalStep();
                    return;
                  }else{
                    traversal = DfsTraversal(graph.adjacencyMatrix);
                    traversal?.startTraversal();
                  } 
                });
              },
              child: const Text("DFS"),
            )
          ],
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
