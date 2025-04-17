import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lab3/graph_painter.dart';
import 'package:lab3/graph_painters/undirected_graph_panter.dart';

class WeightUnDirectedGraphWidget extends StatelessWidget {
  const WeightUnDirectedGraphWidget({super.key, required this.adjacencyMatrix, required this.size, required this.weightMatrix});
  final List<List<int>> adjacencyMatrix;
  final List<List<int>> weightMatrix;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: WeightGraphPainter(adjacencyMatrix: adjacencyMatrix, weightMatrix: weightMatrix),
    );
  }
}

class WeightGraphPainter extends GraphUnDirectedPainter{
  final List<List<int>> weightMatrix;
  String text = ''; 

  WeightGraphPainter({required super.adjacencyMatrix, required this.weightMatrix});

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
  }

  @override
  void drawBrokenLine(Canvas canvas, Paint paint, Offset p1, Offset p2, bool clockwise) { 
    final Offset center = calculateOffsetOfGravityCenter(p1, p2, !clockwise);
    final direction = p2 - p1;
    final distance = direction.distance;
    final unitDir = direction / distance;
    p1 = p1 + unitDir * circleRadius;
    p2 = p2 - unitDir * circleRadius;
    canvas.drawLine(p1, center, paint);
    drawTextAlongVector(canvas, p1, center, text);
    canvas.drawLine(center, p2, paint);
    drawTextAlongVector(canvas, center, p2, text);
  }

  @override
  void drawLine(Canvas canvas, Paint paint, Offset p1, Offset p2) {
    final direction = p2 - p1;
    final distance = direction.distance;

    final unitDir = direction / distance;
    p1 = p1 + unitDir * circleRadius;
    p2 = p2 - unitDir * circleRadius;
    canvas.drawLine(p1, p2, paint);
    drawTextAlongVector(canvas, p1, p2, text);  
  }

  void drawTextAlongVector(Canvas canvas, Offset start, Offset end, String text) {
    final vector = end - start;
    
    final angle = vector.direction;

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();

    final center = (start + end) /2;
    canvas.translate(center.dx, center.dy);

    double adjustedAngle = angle;
    if (angle > pi / 2 && angle < 3 * pi / 2) {
      adjustedAngle += pi;  
    }

    canvas.rotate(adjustedAngle);

    textPainter.paint(canvas, Offset(0, -textPainter.height / 2));

    canvas.restore();
    textPainter.dispose();
  }

}