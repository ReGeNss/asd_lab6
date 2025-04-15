abstract class Traversal{
  final List<List<int>> adjacencyMatrix;
  final List<TraversalVertexInfo> vertexInfo = [];
  int visitNumber = 0;

  Traversal(this.adjacencyMatrix){
    for(int i = 0; i < adjacencyMatrix.length; i++){
      final neighbors = <int>[];
      for(int j = 1; j < adjacencyMatrix[i].length; j++){
        if(adjacencyMatrix[i][j] == 1){
          neighbors.add(j);
        }
      }
      vertexInfo.add(TraversalVertexInfo(i, neighbors));
    }
  }

  void startTraversal({int startVertexIndex = 0});

  void traversalStep();
}

class TraversalVertexInfo{
  final int index;
  int visitNumber = -1;
  int visitedFrom = -1; 
  bool isClosed = false;
  List<int> neighbors;
  bool isActive = false;

  TraversalVertexInfo(this.index, this.neighbors);
}