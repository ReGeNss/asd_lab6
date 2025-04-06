abstract class GraphAnalyzer{
  final List<List<int>> adjacencyMatrix;

  GraphAnalyzer(this.adjacencyMatrix);

  List<int> getDegreeOfVertexs();

  int? isRegular(){
    List<int> degrees = getDegreeOfVertexs();
    bool isRegular = degrees.every((deg) => deg == degrees[0]);
    return isRegular ? degrees[0] : null;
  }

  List<int> getPendantVertex(){
    List<int> degrees = getDegreeOfVertexs();
    return List.generate(degrees.length, (i) => i).where((i) => degrees[i] == 1).toList();
  }

  List<int> getIsolatedVertex(){
    List<int> degrees = getDegreeOfVertexs();
    return List.generate(degrees.length, (i) => i).where((i) => degrees[i] == 0).toList();
  }

  String getGraphInfo();
}
