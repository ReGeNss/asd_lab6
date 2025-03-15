import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lab3/graph_painters/directed_graph_painter.dart';
import 'package:lab3/graph_painters/undirected_graph_panter.dart';

const _groopNumber = 41;
const _variantNumber = 15;
const _countOfVertex = 11;
const _k = 1 - 1 * 0.02 - 4 * 0.005 - 0.25; 

class Graph {
  final List<List<int>> adjacencyMatrix;
  final Widget graphWidget;
  
  Graph._(this.graphWidget, this.adjacencyMatrix);
  
  factory Graph.generate(bool isDirected, double size) {
    final adjacencyMatrix = _generateGraph();
    if(!isDirected) {
      convertToUnDirected(adjacencyMatrix);
    }
    Graph graph = Graph._( 
      isDirected 
        ? DirectedGraphWidget(adjacencyMatrix: adjacencyMatrix, size: size)
        : UnDirectedGraphWidget(adjacencyMatrix: adjacencyMatrix, size: size),
      adjacencyMatrix
    );
    return graph;
  }

  static List<List<int>> _generateGraph() {
    Random random = Random(_groopNumber * _variantNumber);
    final randomMatrix = _generateRandomMatrix(random);
    for(int i = 0; i < randomMatrix.length; i++) {
      for(int j = 0; j < randomMatrix[i].length; j++) {
        if(i == j) {
          randomMatrix[i][j]*=_k;
        }
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

  static List<List<double>> _generateRandomMatrix(Random random) {
    List<List<double>> matrix = [];
    for (int i = 0; i < _countOfVertex; i++) {
      matrix.add([]);
      for (int j = 0; j < _countOfVertex; j++) {
        matrix[i].add(random.nextDouble() * 2);
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
}