// import 'package:lab3/graph_traversal/traversal.dart';
import 'package:flutter/material.dart';
import 'package:lab3/graph_painter.dart';
import 'package:lab3/graph_traversal/traversal.dart';
import 'directed_graph_painter.dart';

const colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.brown,
  Colors.cyan,
  Colors.teal,
  Colors.indigo,
  Colors.amber,
];

class TraversalPainter extends GraphDirectedPainter {
  final List<TraversalVertexInfo> vertexInfo;
  TraversalPainter({required super.adjacencyMatrix, required this.vertexInfo,});

  @override
  void drawGraph(Canvas canvas, Paint paint, TextPainter textPainter) {
    final adjacencyMatrixCopy = adjacencyMatrix.map((e) => e.toList()).toList();

    for(int i = 0; i < countOfVertex; i++) {
      final relationsWithThatVertex = adjacencyMatrixCopy[i];
      final vertexOffset = offsetsOfVertex[i];
      if(vertexInfo[i].isActive){
        canvas.drawCircle(vertexOffset, circleRadius, paint..color = Colors.red);
        paint.color = Colors.black;
      }else if(vertexInfo[i].isClosed){
        canvas.drawCircle(
          vertexOffset,
          circleRadius,
          paint..color = Colors.orange,
        );
        paint.color = Colors.black;
      }
      else if(vertexInfo[i].visitNumber >= 0){ 
        canvas.drawCircle(
          vertexOffset,
          circleRadius,
          paint..color = Colors.cyan,
        );
      }else{
        canvas.drawCircle(
          vertexOffset,
          circleRadius,
          paint,
        );
      }
      paint.color = Colors.black;
      for(int j = 0; j < relationsWithThatVertex.length; j++) {
        final isSelfLoop = relationsWithThatVertex[j] == 1 && i == j;
        if(isSelfLoop) {
          final sideOfVertex = getSideOfVertex(i);
          drawSelfLoop(canvas,paint, vertexOffset, Sides.values[sideOfVertex-1]);
        } else if(relationsWithThatVertex[j] == 1) {
          drawLineBetweenVertex(canvas, paint, i, j, vertexOffset);
          paint.color = Colors.black;
        }
        drawText(textPainter, canvas, vertexOffset, (i+1).toString()); 
      }
    }
    
    for(int i=0; i < vertexInfo.length; i++){
      final visitNumber = vertexInfo[i].visitNumber;
      if(visitNumber > 0){
        final visitedFrom = vertexInfo[i].visitedFrom;
        final visitedFromOffset = offsetsOfVertex[visitedFrom];
        drawLineBetweenVertex(canvas, paint..color = colors[visitNumber], visitedFrom, i, visitedFromOffset);
      }
    }
  }
}