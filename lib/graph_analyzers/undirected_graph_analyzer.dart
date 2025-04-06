import 'graph_analyzer.dart';

class UndirectedGraphAnalyzer extends GraphAnalyzer {
  UndirectedGraphAnalyzer(super.adjacencyMatrix);

  @override
  List<int> getDegreeOfVertexs() {
    return List.generate(adjacencyMatrix.length, (i) {
      int degree = 0;
      if(adjacencyMatrix[i][0] == 1){
        degree+= 2;
      }
      for (int j = 1; j < adjacencyMatrix.length; j++) {
        degree += adjacencyMatrix[i][j];
      }
      return degree;
    });
  }

  @override
  String getGraphInfo() {
    final degrees = getDegreeOfVertexs();
    final isReg = isRegular();
    final pendants = getPendantVertex();
    final isolated = getIsolatedVertex();

    return '''\n
      Степені вершин: $degrees
      isRegular: ${isReg != null ? 'Так, степінь $isReg' : 'Ні'}
      Висячі вершини: ${pendants.isEmpty ? 'немає' : pendants}
      Ізольовані вершини: ${isolated.isEmpty ? 'немає' : isolated}
    ''';
  }
}
