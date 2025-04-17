import 'package:flutter/material.dart';
import 'package:lab3/graph.dart';
import 'package:lab3/graph_painters/backbone_painter.dart';
import 'package:lab3/graph_painters/directed_graph_painter.dart';
import 'package:lab3/graph_painters/undirected_graph_panter.dart';
import 'package:lab3/graph_painters/weight_graph_painter.dart';
import 'package:lab3/graph_traversal/bfs_traversal.dart';
import 'package:lab3/graph_traversal/dfs_traversal.dart';
import 'package:lab3/graph_traversal/mst_prime_traversal.dart';
import 'package:lab3/graph_traversal/traversal.dart';

const double size = 500;

enum GraphType {
  mfs,
  bfs,
  dfs,
  directed,
  undirected,
  undirectedWeighted,
}

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
  bool isDirected = false;
  late Graph graph;
  GraphType state = GraphType.directed;
  Traversal? traversal;
  MstPrimeTraversal?  mstTraversal; 

  @override
  void initState() {
    graph = Graph.generate(isDirected, size);
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
            switch(state) {
              GraphType.directed => DirectedGraphWidget(
                  adjacencyMatrix: graph.adjacencyMatrix,
                  size: size,
                ),
              GraphType.undirected => UnDirectedGraphWidget(
                  adjacencyMatrix: graph.adjacencyMatrix,
                  size: size,
                ),
              GraphType.mfs => BackboneUnDirectedGraphWidget(
                  adjacencyMatrix: graph.adjacencyMatrix,
                  size: size,
                  sum: mstTraversal?.mstVertexWeight ?? 0,
                  weightMatrix: graph.weightMatrix,
                  mstRes: mstTraversal?.result ?? [],
                ),
              GraphType.bfs => DirectedGraphWidget(
                  adjacencyMatrix: graph.adjacencyMatrix,
                  vertexInfo: traversal?.vertexInfo ?? [],
                  size: size,
                ),
              GraphType.dfs => DirectedGraphWidget(
                  adjacencyMatrix: graph.adjacencyMatrix,
                  vertexInfo: traversal?.vertexInfo ?? [],
                  size: size,
                ),
              GraphType.undirectedWeighted => WeightUnDirectedGraphWidget(
                adjacencyMatrix: graph.adjacencyMatrix,
                size: size,
                weightMatrix: graph.weightMatrix,
              ),
            }
          ],
        ),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                setState(() {
                  state = GraphType.directed;
                  graph = Graph.generate(true, size);
                });
              },
              child: Text('Directed'),
            ),
             FilledButton(
              onPressed: () {
                setState(() {
                  state = GraphType.undirected;
                  graph = Graph.generate(false, size);
                });
              },
              child: Text('Undirected'),
            ),
             FilledButton(
              onPressed: () {
                setState(() {
                  state = GraphType.undirectedWeighted;
                  graph = Graph.generate(false, size);
                });
              },
              child: Text('Undirected Weighted'),
            ),
            FilledButton(
              onPressed: (){
                setState(() {
                  if(traversal != null && traversal is BfsTraversal){
                    traversal?.traversalStep();
                    return;
                  }else{
                    state = GraphType.bfs;
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
                    state = GraphType.dfs;
                    traversal = DfsTraversal(graph.adjacencyMatrix);
                    traversal?.startTraversal();
                  } 
                });
              },
              child: const Text("DFS"),
            ),
              FilledButton(
              onPressed: () {
                if(mstTraversal != null){
                  mstTraversal?.traversalStep();
                  return;
                }else{
                  state = GraphType.mfs;
                  mstTraversal = MstPrimeTraversal(graph.adjacencyMatrix, graph.weightMatrix);
                  mstTraversal?.startTraversal();
                } 
                setState(() {
                  
                });
              },
              child: const Text("MFS"),
            ),

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
