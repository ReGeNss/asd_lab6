import 'dart:math';

const _groupNumber = 41;
const _variantNumber = 15;
const _countOfVertex = 11;

const _k = 1 - 1 * 0.01 - 5 * 0.005 - 0.05; 

class Graph {
  final List<List<int>> adjacencyMatrix;
  static final _random = Random(_groupNumber * _variantNumber);
  List<List<int>> weightMatrix = [];

  Graph._(this.adjacencyMatrix){
    weightMatrix = createWeightMatrix(adjacencyMatrix);
  }
  
  factory Graph.generate(bool isDirected, double size) {
    final adjacencyMatrix = _generateGraph();
    if(!isDirected) {
      convertToUnDirected(adjacencyMatrix);
    }
    Graph graph = Graph._( 
      adjacencyMatrix
    );
    return graph;
  }

  factory Graph.directedFromAdjacencyMatrix(List<List<int>> adjacencyMatrix, double size) {
    Graph graph = Graph._( 
      adjacencyMatrix
    );
    return graph;
  }

  static List<List<int>> _generateGraph() {
    final randomMatrix = _generateRandomMatrix();
    for(int i = 0; i < randomMatrix.length; i++) {
      for(int j = 0; j < randomMatrix[i].length; j++) {
        randomMatrix[i][j]*=_k;
      }
    }
    final List<List<int>> matrix = [];
    for(int i = 0; i < randomMatrix.length; i++) {
      matrix.add([]);
      for(int j = 0; j < randomMatrix[i].length; j++) {
        if(randomMatrix[i][j] >= 1) {
          matrix[i].add(1);
        }else { 
          matrix[i].add(0);
        }
      }
    }
    return matrix;
  }

  static List<List<double>> _generateRandomMatrix() {
    List<List<double>> matrix = [];
    for (int i = 0; i < _countOfVertex; i++) {
      matrix.add([]);
      for (int j = 0; j < _countOfVertex; j++) {
        matrix[i].add(_random.nextDouble() * 2);
      }
    }
    return matrix;
  }

  static void convertToUnDirected(List<List<int>> matrix) {
    for(int i = 0; i < matrix.length; i++) {
      for(int j = i+1; j < matrix.length; j++) {
        if (matrix[i][j] == 1 || matrix[j][i] == 1) {
          matrix[i][j] = 1;
          matrix[j][i] = 1;
        }
      }
    }
  }

  static List<List<int>> createWeightMatrix(List<List<int>> adjacencyMatrix){
    final bMatrix = _generateRandomMatrix();
    convertToUnDirected(adjacencyMatrix);
    final List<List<int>> cMatrix = List.generate(adjacencyMatrix.length, (i) => []);
    for(int i = 0; i < adjacencyMatrix.length; i++) {
      for(int j = 0; j < adjacencyMatrix[i].length; j++) {
        cMatrix[i].add((adjacencyMatrix[i][j] * bMatrix[i][j] * 100).ceil());
      }
    }
    final dMatrix = List.generate(adjacencyMatrix.length, (i) => []);
    for(int i = 0; i < adjacencyMatrix.length; i++) {
      for(int j = 0; j < adjacencyMatrix[i].length; j++) {
        if(cMatrix[i][j] == 0){
          dMatrix[i].add(0);
        }else{
          dMatrix[i].add(1);
        }
      }
    }
    final hMatrix = List.generate(adjacencyMatrix.length, (i) => []);
    for(int i = 0; i < adjacencyMatrix.length; i++) {
      for(int j = 0; j < adjacencyMatrix[i].length; j++) {
        if(dMatrix[i][j] != dMatrix[j][i]){
          hMatrix[i].add(1);
        }else{
          hMatrix[i].add(0);
        }
      }
    }
    final trMatrix = List.generate(adjacencyMatrix.length, (i) => []);
    for(int i = 0; i < adjacencyMatrix.length; i++) {
      for(int j = 0; j < adjacencyMatrix[i].length; j++) {
        if(i < j){
          trMatrix[i].add(1);
        }else{
          trMatrix[i].add(0);
        }
      }
    }
    final List<List<int>> weightMatrix = List.generate(adjacencyMatrix.length, (i) => List.generate(adjacencyMatrix.length, (j) => 0));
    for(int i = 0; i < adjacencyMatrix.length; i++) {
      for(int j = 0; j < adjacencyMatrix[i].length; j++) {
        final value = (dMatrix[i][j] + hMatrix[i][j] * trMatrix[i][j]) * cMatrix[i][j];
          weightMatrix[i][j] = value;
          weightMatrix[j][i] = value;
        // }
      }
    }

    for(int i = 0; i < adjacencyMatrix.length; i++) {
      weightMatrix[i][i] = 0;
    }

    for(int i = 0; i < adjacencyMatrix.length; i++) {
      print('${i+1}: ${weightMatrix[i]}');
    }

    return weightMatrix; 
  }
}
