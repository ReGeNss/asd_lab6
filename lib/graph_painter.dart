import 'dart:math';
import 'package:flutter/material.dart';

const brokenLineHeigth = 100.0;
const arrowHeadLength = 10.0;
const arrowAngle = pi / 6; 
const baseIndex = 2;
const circleRadius = 20.0;

enum Sides {
  left,
  right,
  base,
}

class GraphPainter extends CustomPainter {
  final List<List<int>> adjacencyMatrix;
  final List<Offset> offsetsOfVertex = [];
  late final List<int> sidesIndexes;
  late final int countOfVertex;
  late final int maxCountOfVertexOnSide;
  late final List<List<int>> lines;

  GraphPainter({required this.adjacencyMatrix}){
    countOfVertex = adjacencyMatrix.length;
    maxCountOfVertexOnSide = (countOfVertex / 3).floor();
    sidesIndexes = [
      0,
      maxCountOfVertexOnSide,
      2 * maxCountOfVertexOnSide + 1,
    ];
    lines = buildLines(countOfVertex, sidesIndexes);
  }

  void calculateOffsetsOfVertex(Size workAreaSize) {
    final height = workAreaSize.width * 1.732 / 2; // because of equilateral triangle
    final width = workAreaSize.width;
    final widthOfSide = width / 2;

    final countOfVertexOnFirstSide = sidesIndexes[1] - sidesIndexes[0];
    final countOfVertexOnSecondSide = sidesIndexes[2] - sidesIndexes[1];
    final countOfVertexOnThirdSide = countOfVertex - sidesIndexes[2];

    for(int i = 0; i < countOfVertex; i++) {
      if(i >= sidesIndexes[0] && i < sidesIndexes[1]) {
        final distanceBetweenVertexByWidht = widthOfSide / countOfVertexOnFirstSide;
        final distanceBetweenVertexByHeight = height / countOfVertexOnFirstSide;

        final offsetDx = distanceBetweenVertexByWidht * i;
        final offsetDy = height - distanceBetweenVertexByHeight * i;
        offsetsOfVertex.add(Offset(offsetDx, offsetDy));
      }else if( i >= sidesIndexes[1] && i < sidesIndexes[2]) {
        final distanceBetweenVertexByWidht = widthOfSide / countOfVertexOnSecondSide;
        final distanceBetweenVertexByHeight = height / countOfVertexOnSecondSide;
        final offsetCoefficient = i - sidesIndexes[1];

        final offsetDx = widthOfSide + distanceBetweenVertexByWidht * offsetCoefficient;
        final offsetDy = distanceBetweenVertexByHeight * offsetCoefficient;
        offsetsOfVertex.add(Offset(offsetDx, offsetDy));
      }else {
        final distanceBetweenVertexByWidht = width / countOfVertexOnThirdSide;
        final offsetCoefficient = i - sidesIndexes[2];

        final offsetDx = distanceBetweenVertexByWidht * countOfVertexOnThirdSide + distanceBetweenVertexByWidht * (-offsetCoefficient);
        final offsetDy = height;
        offsetsOfVertex.add(Offset(offsetDx, offsetDy));
      }
    }
  }

  int getSideOfVertex(int indexOfVertex){
    if(indexOfVertex <= sidesIndexes[1]){
      return 1;
    }else if(indexOfVertex >= sidesIndexes[1] && indexOfVertex < sidesIndexes[2]){
      return 2;
    }else {
      return 3;
    }
  }
  
  void drawText(TextPainter textPainter, Canvas canvas, Offset point, String text) { 
    textPainter.text = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      )
    );
    
    textPainter.layout(minWidth: circleRadius);
    final textHeiht = textPainter.height;

    final offsetToText = Offset(
      point.dx - circleRadius / 2, 
      point.dy - textHeiht / 2
    );
    textPainter.paint(canvas, offsetToText); 
  }

  Offset calculateOffsetOfGravityCenter(Offset p1, Offset p2, bool clockwise) {
    final double dx, dy;
    final double deltaX = p2.dx - p1.dx;
    final double deltaY = p2.dy - p1.dy;
    final double distance = (p1 - p2).distance;

    final double normalX = -deltaY / distance;
    final double normalY = deltaX / distance;

    final double midX = (p1.dx + p2.dx) / 2;
    final double midY = (p1.dy + p2.dy) / 2;

    final double heigth = brokenLineHeigth;
    final double direction = clockwise ? 1 : -1;

    dx = midX + direction * heigth * normalX;
    dy = midY + direction * heigth * normalY;

    return Offset(dx, dy);
  }
  
  bool isNeigbour(int indexOfVertex, int indexOfRelatedVertex){
    bool isA = false; 
    for(int line = 0; line < lines.length; line++){
      if(lines[line].contains(indexOfVertex) && lines[line].contains(indexOfRelatedVertex)){
        final p1 = lines[line].indexOf(indexOfVertex);
        final p2 = lines[line].indexOf(indexOfRelatedVertex);
        if((p1 - p2).abs() == 1){
          return false;
        }else{
          isA = true;
        }
      }
    }
    if(!isA) {
      return false;
    }
    return true; 
  }

  bool isClockwise(int p1, int p2) {
    final side = getSide(p1, p2);
    if(side == Sides.left){
      return p1 < p2; 
    }else if(side == Sides.right){
      return p1 < p2;
    }else {	
      if((p1 - p2).abs() > maxCountOfVertexOnSide){
        if(p1 > p2){
          return true;
        }
        return false;
      }else if(p1 > p2){
        return false;
      }
      return true;
    } 
  }

  List<List<int>> buildLines(int countOfVertex, List<int> corners) {
  final List<int> perimeter = List.generate(countOfVertex, (index) => index);
  final List<List<int>> lines = [];
  final int nCorners = corners.length;
  
  for (int i = 0; i < nCorners; i++) {
    int startCorner = corners[i];
    int endCorner = corners[(i + 1) % nCorners];
    
    int startIndex = perimeter.indexOf(startCorner);
    int endIndex = perimeter.indexOf(endCorner);
    
    List<int> segment;
    if (startIndex <= endIndex) { // left and right side
      segment = perimeter.sublist(startIndex, endIndex + 1);
    } else { // base 
      segment = [
        ...perimeter.sublist(startIndex),
        ...perimeter.sublist(0, endIndex + 1)
      ];
    }
    
    lines.add(segment);
  }
  
  lines[baseIndex] = lines[baseIndex].reversed.toList();
  return lines;
}

   Sides getSide(int p1, int p2) {
    if(lines[0].contains(p1) && lines[0].contains(p2)){
      return Sides.left;
    }
    if(lines[1].contains(p1) && lines[1].contains(p2)){
      return Sides.right;
    }
    return Sides.base;
  }

  @override
  void paint(Canvas canvas, Size size) {
    throw UnimplementedError("you should implement this method in your class");
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}