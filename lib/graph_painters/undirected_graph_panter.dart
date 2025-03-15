import 'package:flutter/material.dart';
import 'package:lab3/graph_painter.dart';

class UnDirectedGraphWidget extends StatelessWidget {
  const UnDirectedGraphWidget({super.key, required this.adjacencyMatrix, required this.size});
  final List<List<int>> adjacencyMatrix;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GraphUnDirectedPainter(adjacencyMatrix: adjacencyMatrix),
    );
  }
}

class _GraphUnDirectedPainter extends GraphPainter {
  _GraphUnDirectedPainter({required super.adjacencyMatrix});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2;
    TextPainter textPainter = TextPainter(); 
    textPainter.textDirection = TextDirection.ltr;
    textPainter.textAlign = TextAlign.center;
    calculateOffsetsOfVertex(size);

    _drawGraph(canvas, paint, textPainter);
  }

  void _drawGraph(Canvas canvas, Paint paint, TextPainter textPainter) {
    final adjacencyMatrixCopy = adjacencyMatrix.map((e) => e.toList()).toList();

    for(int i = 0; i < countOfVertex; i++) {
      final relationsWithThatVertex = adjacencyMatrixCopy[i];
      final vertexOffset = offsetsOfVertex[i];
      canvas.drawCircle(
        vertexOffset,
        circleRadius,
        paint
      );
      for(int j = 0; j < relationsWithThatVertex.length; j++) {
        final isSelfLoop = relationsWithThatVertex[j] == 1 && i == j;
        if(isSelfLoop) {
          final sideOfVertex = getSideOfVertex(i);
          drawSelfLoop(canvas,paint, vertexOffset, Sides.values[sideOfVertex-1]);
        }else if(relationsWithThatVertex[j] == 1) {
          _drawLineBetweenVertex(canvas, paint, i, j, vertexOffset);
          adjacencyMatrixCopy[j][i] = 0;
        }
        drawText(textPainter, canvas, vertexOffset, (i+1).toString()); 
      }
    }
  }

  void _drawLineBetweenVertex(Canvas canvas, Paint paint, int indexOfVertex, int indexOfRelatedVertex, Offset offsetOfVertex) {
    paint.style = PaintingStyle.stroke;
    final offsetOfRelatedVertex = offsetsOfVertex[indexOfRelatedVertex];
    
    if(isNeigbour(indexOfVertex, indexOfRelatedVertex)){
      final clockwise = isClockwise(indexOfVertex, indexOfRelatedVertex);
      drawBrokenLine(canvas, paint, offsetOfVertex, offsetOfRelatedVertex, clockwise);
    }else {
      drawLine(canvas, paint, offsetOfVertex, offsetOfRelatedVertex);
    }
    paint.style = PaintingStyle.fill;
  }

  void drawSelfLoop(Canvas canvas, Paint paint, Offset offsetOfVertex, Sides side) {
    late final Offset p1;
    late final Offset p2;
    late final bool clockwise;
    if(Sides.left == side){ 
      clockwise = true;
      p1= Offset(offsetOfVertex.dx, offsetOfVertex.dy + circleRadius);
      p2 = Offset(offsetOfVertex.dx- circleRadius, offsetOfVertex.dy);
    }else if(Sides.right == side){ 
      clockwise = false;
      p1= Offset(offsetOfVertex.dx + circleRadius, offsetOfVertex.dy);
      p2 = Offset(offsetOfVertex.dx, offsetOfVertex.dy - circleRadius);
    }else{
      clockwise = true;
      p1 = Offset(offsetOfVertex.dx, offsetOfVertex.dy + circleRadius);
      p2 = Offset(offsetOfVertex.dx - circleRadius, offsetOfVertex.dy);
    }

    paint.style = PaintingStyle.stroke;
    Path path = Path();

    path.moveTo(p1.dx, p1.dy);
    path.arcToPoint(p2, radius: Radius.circular(circleRadius), largeArc: true, clockwise: clockwise);
    canvas.drawPath(path, paint);
    
    paint.style = PaintingStyle.fill;
  }

  void drawBrokenLine(Canvas canvas, Paint paint, Offset p1, Offset p2, bool clockwise) { 
    final Offset center = calculateOffsetOfGravityCenter(p1, p2, !clockwise);
    canvas.drawLine(p1, center, paint);
    canvas.drawLine(center, p2, paint);
  }

  void drawLine(Canvas canvas, Paint paint, Offset p1, Offset p2) {
    final Offset direction = p2 - p1;
    final double distance = direction.distance;

    final Offset unitDir = direction / distance;
    final Offset circleLocation = p2 - unitDir * circleRadius;
    canvas.drawLine(p1, circleLocation, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}