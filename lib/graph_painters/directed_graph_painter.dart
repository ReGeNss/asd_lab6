import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lab3/graph_painter.dart';

class DirectedGraphWidget extends StatelessWidget {
  const DirectedGraphWidget({super.key, required this.adjacencyMatrix, required this.size});
  final List<List<int>> adjacencyMatrix;
  final double size; 

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GraphDirectedPainter(adjacencyMatrix: adjacencyMatrix),
    );
  }
}

class _GraphDirectedPainter extends GraphPainter {
  _GraphDirectedPainter({required super.adjacencyMatrix});

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
        }else if(relationsWithThatVertex[j] == 1 && adjacencyMatrixCopy[j][i] == 1) {
          _drawLineBetweenVertex(canvas, paint, i, j, vertexOffset , drawStartArrow: true);
          adjacencyMatrixCopy[j][i] = 0;
        } else if(relationsWithThatVertex[j] == 1) {
          _drawLineBetweenVertex(canvas, paint, i, j, vertexOffset);          
        }
        drawText(textPainter, canvas, vertexOffset, (i+1).toString()); 
      }
    }
  }

  void _drawLineBetweenVertex(Canvas canvas, Paint paint, int indexOfVertex, int indexOfRelatedVertex, Offset offsetOfVertex, {bool drawStartArrow = false}) {
    paint.style = PaintingStyle.stroke;
    final offsetOfRelatedVertex = offsetsOfVertex[indexOfRelatedVertex];
    
    if(isNeigbour(indexOfVertex, indexOfRelatedVertex)){
       
      final clockwise = isClockwise(indexOfVertex, indexOfRelatedVertex);
      drawBrokenLine(canvas, paint, offsetOfVertex, offsetOfRelatedVertex, clockwise, drawStartArrow);
    }else {
      drawArrow(canvas, offsetOfVertex, offsetOfRelatedVertex, paint, drawStartArrow: drawStartArrow);	
    }
    paint.style = PaintingStyle.fill;
  }

  void drawSelfLoop(Canvas canvas, Paint paint, Offset offsetOfVertex, Sides side) {
    late final Offset p1;
    late final Offset p2;
    late final bool clockwise;
    if(Sides.left == side){ 
      clockwise = true;
      drawArrow(canvas, offsetOfVertex - Offset(1,0), offsetOfVertex, paint);
      p1= Offset(offsetOfVertex.dx, offsetOfVertex.dy + circleRadius);
      p2 = Offset(offsetOfVertex.dx- circleRadius, offsetOfVertex.dy);
    }else if(Sides.right == side){ 
      clockwise = false;
      drawArrow(canvas, offsetOfVertex + Offset(1,0), offsetOfVertex, paint);
      p1= Offset(offsetOfVertex.dx + circleRadius, offsetOfVertex.dy);
      p2 = Offset(offsetOfVertex.dx, offsetOfVertex.dy - circleRadius);
    }else{
      clockwise = true;
      drawArrow(canvas, offsetOfVertex + Offset(0,1), offsetOfVertex, paint);
      p1 = Offset(offsetOfVertex.dx, offsetOfVertex.dy + circleRadius);
      p2 = Offset(offsetOfVertex.dx - circleRadius, offsetOfVertex.dy);
    }

    paint.style = PaintingStyle.stroke;
    Path path = Path();
    canvas.drawPath(path, paint);

    path.moveTo(p1.dx, p1.dy);
    path.arcToPoint(p2, radius: Radius.circular(circleRadius), largeArc: true, clockwise: clockwise);
    canvas.drawPath(path, paint);
    
    paint.style = PaintingStyle.fill;
  }

  void drawBrokenLine(Canvas canvas, Paint paint, Offset p1, Offset p2, bool clockwise, bool drawStartArrow, {double koef = 1} ) { 
    final Offset center = calculateOffsetOfGravityCenter(p1, p2, !clockwise);
    if(drawStartArrow){
      drawArrow(canvas, center, p1, paint);
    }else{
      canvas.drawLine(p1, center, paint);
    }
    drawArrow(canvas, center, p2, paint);
  }

  void drawArrow(Canvas canvas, Offset p1, Offset p2, Paint paint, {bool drawStartArrow = false}) {
    final Offset direction = p2 - p1;
    final double distance = direction.distance;

    final Offset unitDir = direction / distance;
    final Offset arrowTip = p2 - unitDir * circleRadius;

    canvas.drawLine(p1, arrowTip, paint);

    _drawArrowHead(canvas, paint, arrowTip, unitDir);

    if (drawStartArrow) {
      final Offset startTip = p1 + unitDir * circleRadius;
      _drawArrowHead(canvas, paint,startTip, -unitDir);
    }
  }

  void _drawArrowHead(Canvas canvas, Paint paint, Offset tip, Offset dir) {
    final Offset leftDir = Offset(
      dir.dx * cos(arrowAngle) - dir.dy * sin(arrowAngle),
      dir.dx * sin(arrowAngle) + dir.dy * cos(arrowAngle),
    );
    final Offset rightDir = Offset(
      dir.dx * cos(-arrowAngle) - dir.dy * sin(-arrowAngle),
      dir.dx * sin(-arrowAngle) + dir.dy * cos(-arrowAngle),
    );

    final Offset leftPoint = tip - leftDir * arrowHeadLength;
    final Offset rightPoint = tip - rightDir * arrowHeadLength;

    canvas.drawLine(tip, leftPoint, paint);
    canvas.drawLine(tip, rightPoint, paint);
  }

}
