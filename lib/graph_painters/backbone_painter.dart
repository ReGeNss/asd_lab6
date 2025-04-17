import 'package:flutter/material.dart';
import 'package:lab3/graph_painter.dart';
import 'package:lab3/graph_painters/weight_graph_painter.dart';

class BackboneUnDirectedGraphWidget extends StatelessWidget {
  const BackboneUnDirectedGraphWidget({super.key, required this.adjacencyMatrix, required this.size, required this.weightMatrix, required this.mstRes, required this.sum});
  final List<List<int>> adjacencyMatrix;
  final List<List<int>> mstRes;
  final List<List<int>> weightMatrix;
  final double size;
  final int sum;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          size: Size.square(size),
          painter: BackbonePainter(adjacencyMatrix: adjacencyMatrix, weightMatrix: weightMatrix, mstResult: mstRes),
        ),
        const SizedBox(height: 40),
        Text('Сума ваг мін. кістяка: $sum')
      ],
    );
  }
}

class BackbonePainter extends WeightGraphPainter {
  List<List<int>> mstResult;

  BackbonePainter({required super.adjacencyMatrix, required super.weightMatrix, required this.mstResult});

  @override
  void drawGraph(Canvas canvas, Paint paint, TextPainter textPainter) {
    final adjacencyMatrixCopy = adjacencyMatrix.map((e) => e.toList()).toList();

    for(int i = 0; i < countOfVertex; i++) {
      final relationsWithThatVertex = adjacencyMatrixCopy[i];
      final vertexOffset = offsetsOfVertex[i];
      canvas.drawCircle(
        vertexOffset,
        circleRadius,
        paint
      );
      for(int j = i; j < relationsWithThatVertex.length; j++) {
        final isSelfLoop = relationsWithThatVertex[j] == 1 && i == j;
        if(isSelfLoop) {
          final sideOfVertex = getSideOfVertex(i);
          drawSelfLoop(canvas,paint, vertexOffset, Sides.values[sideOfVertex-1]);
        } else if(relationsWithThatVertex[j] == 1) {
          text = weightMatrix[i][j].toString();
          adjacencyMatrixCopy[j][i] = 0;
          drawLineBetweenVertex(canvas, paint, i, j, vertexOffset);
        }
      }
      drawText(textPainter, canvas, vertexOffset, (i+1).toString()); 
    }
    
    paint.color = Colors.red;
    for(int i =0; i < mstResult.length; i++){ 
      final relationsWithThatVertex = mstResult[i];
      final vertexOffset = offsetsOfVertex[i];
      for(int j = i+1; j < relationsWithThatVertex.length; j++) {
        if(relationsWithThatVertex[j] == 1) {
          text = weightMatrix[i][j].toString();
          drawLineBetweenVertex(canvas, paint, i, j, vertexOffset);
        }
      }
    }
  }
}