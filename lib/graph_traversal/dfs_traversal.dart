import 'dart:collection';
import 'package:lab3/graph_traversal/traversal.dart';

class DfsTraversal extends Traversal{
  late TraversalVertexInfo _currentVertex; 
  final Queue<TraversalVertexInfo> _stack = Queue<TraversalVertexInfo>();

  DfsTraversal(super.adjacencyMatrix); 

  @override
  void startTraversal({int startVertexIndex = 0}){
    vertexInfo[startVertexIndex].visitNumber = 0;
    vertexInfo[startVertexIndex].visitedFrom = -1; // No parent for the starting vertex
    _stack.add(vertexInfo[startVertexIndex]);
    _currentVertex = vertexInfo[startVertexIndex];
    _currentVertex.isActive = true;
  }

  @override
  void traversalStep(){
    if(_currentVertex.neighbors.isEmpty){
      _currentVertex.isClosed = true;
      _currentVertex.isActive = false;
      if(_stack.isEmpty) return;
      _currentVertex = _stack.removeLast();
      _currentVertex.isActive = true;
      return;
    }
    final visitVertexIndex = _currentVertex.neighbors.first;
    _currentVertex.neighbors.remove(visitVertexIndex);
    final visitVertex = vertexInfo[visitVertexIndex];
    if(visitVertex.visitNumber > 0){
      traversalStep();
      return;
    }
    visitVertex.visitNumber = ++visitNumber;
    visitVertex.visitedFrom = _currentVertex.index;
    _stack.add(_currentVertex);
    _currentVertex.isActive = false;
    _currentVertex = visitVertex;
    _currentVertex.isActive = true;

  }
}