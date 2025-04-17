import 'package:collection/collection.dart';

class MstPrimeTraversal {
  final List<List<int>> weightMatrix;
  final List<List<int>> adjacencyMatrix;
  late List<_VertexInfo> _vertexInfo;
  late List<List<int>> result;

  int get mstVertexWeight {
    int sum = 0; 
    final resCopy = result.map((e) => e.toList()).toList();
    for (int i = 0; i < resCopy.length; i++) {
      for (int j = 0; j < resCopy[i].length; j++) {
        if (resCopy[i][j] == 1) {
          sum += weightMatrix[i][j];
          resCopy[i][j] = 0;
        }
      }
    }
    return sum;
  }

  late Set<int> _visitedEdges;
  final _edges = PriorityQueue<_Edge>(
    (a, b) => a.weight.compareTo(b.weight),
  );

  MstPrimeTraversal(this.adjacencyMatrix, this.weightMatrix) {
    final n = adjacencyMatrix.length;
    result = List.generate(n, (_) => List.filled(n, 0));

    _vertexInfo = List.generate(n, (i) {
      final neighbors = <_WeightedVertex>[];
      for (int j = 0; j < n; j++) {
        if (adjacencyMatrix[i][j] == 1) {
          neighbors.add(_WeightedVertex(j, weightMatrix[i][j]));
        }
      }
      return _VertexInfo(i, neighbors);
    });
  }

  void startTraversal({int startVertexIndex = 0}) {
    _visitedEdges = <int>{startVertexIndex};
    _getEdgesFromVertex(startVertexIndex);
  }

  void traversalStep() {
    if (_visitedEdges.length >= _vertexInfo.length || _edges.isEmpty) {
      return;
    }

    _Edge edge;
    do {
      edge = _edges.removeFirst();
    } while (_visitedEdges.contains(edge.to) && _edges.isNotEmpty);

    if (_visitedEdges.contains(edge.to)) {
      return;
    }

    result[edge.from][edge.to] = 1;
    result[edge.to][edge.from] = 1;

    _visitedEdges.add(edge.to);

    _getEdgesFromVertex(edge.to);
  }

  void _getEdgesFromVertex(int vertexIndex) {
    final edges = <_Edge>[];
    for (final neighbor in _vertexInfo[vertexIndex].neighbors) {
      if (!_visitedEdges.contains(neighbor.index)) {
        edges.add(_Edge(vertexIndex, neighbor.index, neighbor.weight));
      }
    }
    _edges.addAll(edges);
  }
}

class _VertexInfo {
  final int index;
  final List<_WeightedVertex> neighbors;

  _VertexInfo(this.index, this.neighbors);
}

class _WeightedVertex {
  final int index;
  final int weight;
  _WeightedVertex(this.index, this.weight);
}

class _Edge {
  final int from;
  final int to;
  final int weight;

  _Edge(this.from, this.to, this.weight);
}
