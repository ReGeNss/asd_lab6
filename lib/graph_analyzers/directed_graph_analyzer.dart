import 'graph_analyzer.dart';

class DirectedGraphAnalyzer extends GraphAnalyzer {
  DirectedGraphAnalyzer(super.adjacencyMatrix);

  @override
  List<int> getDegreeOfVertexs() {
    List<int> degrees = []; 
    final inDegrees = getInDegrees();
    final outDegrees = getOutDegrees();
    for (int i = 0; i < adjacencyMatrix.length; i++) {
      degrees.add(inDegrees[i] + outDegrees[i]);
    }
    return degrees;
  }

  List<int> getInDegrees() {
    int n = adjacencyMatrix.length;
    return List.generate(n, (j) {
      int sum = 0;
      for (int i = 0; i < n; i++) {
        sum += adjacencyMatrix[i][j];
      }
      return sum;
    });
  }

  List<int> getOutDegrees() {
    int n = adjacencyMatrix.length;
    return List.generate(n, (i) => adjacencyMatrix[i].reduce((a, b) => a + b));
  }

  List<List<int>> findPathsOfLength2() {
    int n = adjacencyMatrix.length;
    List<List<int>> paths = [];

    for (int i = 0; i < n; i++) {
      for (int k = 0; k < n; k++) {
        if (adjacencyMatrix[i][k] == 0) continue;
        for (int j = 0; j < n; j++) {
          if (adjacencyMatrix[k][j] == 1) {
            paths.add([i+1, k+1, j+1]);
          }
        }
      }
    }
    return paths;
  }

  List<List<int>> findPathsOfLength3() {
    int n = adjacencyMatrix.length;
    List<List<int>> paths = [];

    for (int i = 0; i < n; i++) {
      for (int k = 0; k < n; k++) {
        if (adjacencyMatrix[i][k] == 0) continue;
        for (int m = 0; m < n; m++) {
          if (adjacencyMatrix[k][m] == 0) continue;
          for (int j = 0; j < n; j++) {
            if (adjacencyMatrix[m][j] == 1) {
              paths.add([i+1, k+1, m+1, j+1]);
            }
          }
        }
      }
    }
    return paths;
  }

  List<List<int>> getReachabilityMatrix() {
    int n = adjacencyMatrix.length;
    List<List<int>> closure = List.generate(n, (i) => List.from(adjacencyMatrix[i]));

    for (int k = 0; k < n; k++) {
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          if (closure[i][k] == 1 && closure[k][j] == 1) {
            closure[i][j] = 1;
          }
        }
      }
    }

    for (int i = 0; i < n; i++) {
      closure[i][i] = 1;
    }
    return closure;
  }

  List<List<int>> getStrongConnectivityMatrix() {
    final reachabilityMatrix = getReachabilityMatrix();
    int n = reachabilityMatrix.length;
    List<List<int>> strongConnectivityMatrix = List.generate(n, (_) => List.filled(n, 0));

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (reachabilityMatrix[i][j] == 1 && reachabilityMatrix[j][i] == 1) {
          strongConnectivityMatrix[i][j] = 1;
        }
      }
    }
    return strongConnectivityMatrix;  
  }

  List<List<int>> getStrongConnectivityComponents() {
    final strong = getStrongConnectivityMatrix();
    int n = strong.length;
    List<bool> visited = List.filled(n, false);
    List<List<int>> components = [];

    for (int i = 0; i < n; i++) {
      if (visited[i]) continue;

      List<int> component = [];
      for (int j = 0; j < n; j++) {
        if (strong[i][j] == 1 && strong[j][i] == 1) {
          component.add(j);
          visited[j] = true;
        }
      }

      if (component.isNotEmpty) {
        components.add(component);
      }
    }
    return components;
  }

  List<List<int>> getCondensedGraph() {
    List<List<int>> components = getStrongConnectivityComponents();
    List<List<int>> condensedMatrix = List.generate(
        components.length, (_) => List.filled(components.length, 0));

    int? compIndex(List<List<int>> components, int vertex) {
      for (int i = 0; i < components.length; i++) {
        if (components[i].contains(vertex)) {
          return i;
        }
      }
      return null;
    }

    for (int i = 0; i < adjacencyMatrix.length; i++) {
      for (int j = 0; j < adjacencyMatrix.length; j++) {
        if (adjacencyMatrix[i][j] == 1) {
          int compI = compIndex(components, i)!;
          int compJ = compIndex(components, j)!;
          if (compI != compJ) {
            condensedMatrix[compI][compJ] = 1;
          }
        }
      }
    }
    return condensedMatrix;
  }

  @override
  String getGraphInfo() {
    final inDeg = getInDegrees();
    final outDeg = getOutDegrees();
    final degrees = getDegreeOfVertexs();
    final isReglular = isRegular();
    final pendants = getPendantVertex();
    final isolated = getIsolatedVertex();

    return '''\n
      In-степені: $inDeg
      Out-степені: $outDeg
      Степені вершин: $degrees
      isRegular: ${isReglular != null ? 'Так, сумарна степінь $isReglular' : 'Ні'}
      Висячі вершини: ${pendants.isEmpty ? 'немає' : pendants}
      Ізольовані вершини: ${isolated.isEmpty ? 'немає' : isolated}
    ''';
  }
}
