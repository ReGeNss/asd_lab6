import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lab3/graph_painter.dart';
import 'package:lab3/graph_painters/traversal_painter.dart';
import 'package:lab3/graph_traversal/traversal.dart';

class DirectedGraphWidget extends StatelessWidget {
  const DirectedGraphWidget({super.key, required this.adjacencyMatrix, required this.size, this.vertexInfo = const []});
  final List<List<int>> adjacencyMatrix;
  final List<TraversalVertexInfo> vertexInfo;
  final double size; 

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: vertexInfo.isEmpty 
        ? GraphDirectedPainter(adjacencyMatrix: adjacencyMatrix)
        : TraversalPainter(adjacencyMatrix: adjacencyMatrix, vertexInfo: vertexInfo)
    );
  }
}

class GraphDirectedPainter extends GraphPainter {
  GraphDirectedPainter({required super.adjacencyMatrix});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2;
    TextPainter textPainter = TextPainter(); 
    textPainter.textDirection = TextDirection.ltr;
    textPainter.textAlign = TextAlign.center;
    calculateOffsetsOfVertex(size);

    drawGraph(canvas, paint, textPainter);
  }

  @protected
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
      for(int j = 0; j < relationsWithThatVertex.length; j++) {
        final isSelfLoop = relationsWithThatVertex[j] == 1 && i == j;
        if(isSelfLoop) {
          final sideOfVertex = getSideOfVertex(i);
          drawSelfLoop(canvas,paint, vertexOffset, Sides.values[sideOfVertex-1]);
        } else if(relationsWithThatVertex[j] == 1) {
          drawLineBetweenVertex(canvas, paint, i, j, vertexOffset);          
        }
        drawText(textPainter, canvas, vertexOffset, (i+1).toString()); 
      }
    }
  }

  void drawLineBetweenVertex(Canvas canvas, Paint paint, int indexOfVertex, int indexOfRelatedVertex, Offset offsetOfVertex) {
    paint.style = PaintingStyle.stroke;
    final offsetOfRelatedVertex = offsetsOfVertex[indexOfRelatedVertex];
    
    if(isNeighbor(indexOfVertex, indexOfRelatedVertex)){
      final clockwise = isClockwise(indexOfVertex, indexOfRelatedVertex);
      drawBrokenLine(canvas, paint, offsetOfVertex, offsetOfRelatedVertex, clockwise);
    }else {
      drawArrow(canvas, offsetOfVertex, offsetOfRelatedVertex, paint, offsetStart: true);	
    }
    paint.style = PaintingStyle.fill;
  }

  void drawSelfLoop(Canvas canvas, Paint paint, Offset offsetOfVertex, Sides side) {
    late final Offset p1;
    late final Offset p2;
    late final bool clockwise;
    if(Sides.left == side){ 
      clockwise = true;
      drawArrowHead(canvas, paint, offsetOfVertex + Offset(-20,0), Offset(1,0));
      p1= Offset(offsetOfVertex.dx, offsetOfVertex.dy + circleRadius);
      p2 = Offset(offsetOfVertex.dx- circleRadius, offsetOfVertex.dy);
    }else if(Sides.right == side){ 
      clockwise = false;
      drawArrowHead(canvas, paint, offsetOfVertex + Offset(20,0), Offset(-1,0));
      p1= Offset(offsetOfVertex.dx + circleRadius, offsetOfVertex.dy);
      p2 = Offset(offsetOfVertex.dx, offsetOfVertex.dy - circleRadius);
    }else{
      clockwise = true;
      drawArrowHead(canvas, paint, offsetOfVertex + Offset(0,20), Offset(0,-1));
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

  void drawBrokenLine(Canvas canvas, Paint paint, Offset p1, Offset p2, bool clockwise) { 
    final Offset center = calculateOffsetOfGravityCenter(p1, p2, !clockwise);
    final Offset direction = p2 - p1;
    final double distance = direction.distance;
    p1 = p1 + direction/distance  * circleRadius;
    canvas.drawLine(p1, center, paint);
    drawArrow(canvas, center, p2, paint, offsetStart: false);
  }

  void drawArrow(Canvas canvas, Offset p1, Offset p2, Paint paint, {bool offsetStart = false}) {
    final Offset direction = p2 - p1;
    final double distance = direction.distance;

    final Offset unitDir = direction / distance;
    if(offsetStart){
      p1 = p1 + unitDir * circleRadius;
    }
    final Offset arrowTip = p2 - unitDir * circleRadius;

    canvas.drawLine(p1, arrowTip, paint);

    drawArrowHead(canvas, paint, arrowTip, unitDir);
  }

  void drawArrowHead(Canvas canvas, Paint paint, Offset tip, Offset dir) {
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
