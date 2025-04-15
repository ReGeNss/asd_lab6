import 'dart:collection';
import 'package:lab3/graph_traversal/traversal.dart';

class BfsTraversal extends Traversal{
  late TraversalVertexInfo currentVertex; 
  Queue<TraversalVertexInfo> queue = Queue<TraversalVertexInfo>();

  BfsTraversal(super.adjacencyMatrix);

  @override
  void startTraversal({int startVertexIndex = 0}){
    vertexInfo[startVertexIndex].visitNumber = 0;
    vertexInfo[startVertexIndex].visitedFrom = -1;
    currentVertex = vertexInfo[startVertexIndex]; 
    currentVertex.isActive = true;
  }

  @override
  void traversalStep(){
    if(currentVertex.isClosed && queue.isEmpty) return;
    
    if(currentVertex.neighbors.isEmpty){
      currentVertex.isClosed = true;
      currentVertex.isActive = false;
      if(queue.isEmpty) return;
      currentVertex = queue.removeFirst();
    }
    final visitVertexIndex = currentVertex.neighbors.first;
    currentVertex.neighbors.remove(visitVertexIndex);
    final visitVertex = vertexInfo[visitVertexIndex];
    if(visitVertex.visitNumber > 0){
      traversalStep();
      return;
    }
    visitVertex.visitNumber = ++visitNumber;
    visitVertex.visitedFrom = currentVertex.index; 
    queue.add(visitVertex);
    if(currentVertex.neighbors.isEmpty){
      currentVertex.isClosed = true;
      currentVertex.isActive = false;
      currentVertex = queue.removeFirst();
      currentVertex.isActive = true;
    }
  }
} 


