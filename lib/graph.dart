import 'dart:math';
import 'package:flutter/material.dart';

const _groopNumber = 41;
const _variantNumber = 15;
const _countOfVertex = 11;
const _k = 1 - 1 * 0.02 - 4 * 0.005 - 0.25; 

class Graph {
  final List<List<int>> adjacencyMatrix;
  final Widget graphWidget;
  
  Graph._(this.graphWidget, this.adjacencyMatrix);
  
  factory Graph.generate() {
    final adjacencyMatrix = _generateGraph();
    Graph graph = Graph._(_GraphWidget(adjacencyMatrix: adjacencyMatrix), adjacencyMatrix);
    return graph;
  }

  static List<List<int>> _generateGraph() {
    Random random = Random(_groopNumber*_variantNumber);
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
    print(matrix);
    List<List<int>> a = [];
    for(int i = 0; i < 11; i++) {
      a.add([]);
      for(int j = 0; j < 11; j++) {
        a[i].add(0);
      }
    }
    // a[0][10] = 1;
    a[10][0] = 1;
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
}

class _GraphWidget extends StatelessWidget {
  const _GraphWidget({super.key, required this.adjacencyMatrix});
  final List<List<int>> adjacencyMatrix;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(550),
      painter: _GraphPainter(adjacencyMatrix: adjacencyMatrix),
    );
  }
}

const double _circleRadius = 20;

class _GraphPainter extends CustomPainter {
  final List<List<int>> adjacencyMatrix;
  late final List<int> sidesIndexes;   
  late final int countOfVertex;
  late final int maxCountOfVertexOnSide;
  final List<Offset> offsetsOfVertex = [];

  _GraphPainter({required this.adjacencyMatrix}){
    countOfVertex = adjacencyMatrix.length; 
    maxCountOfVertexOnSide = (countOfVertex / 3).floor();

    sidesIndexes = [
      0,
      maxCountOfVertexOnSide,
      2 * maxCountOfVertexOnSide + 1,
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2;
    
    _calculateOffsetsOfVertex(size);
    // createRelations();
    TextPainter textPainter = TextPainter(); 
    textPainter.textDirection = TextDirection.ltr;

    for(int i = 0; i < countOfVertex; i++) {
      final relationsWithThatVertex = adjacencyMatrix[i];
      canvas.drawCircle(
        offsetsOfVertex[i],
        _circleRadius,
        paint
      );
      for(int j = 0; j < relationsWithThatVertex.length; j++) {
        if(relationsWithThatVertex[j] == 1 && i == j) {
          drawLoop(canvas,paint, offsetsOfVertex[i]);
        }else if(relationsWithThatVertex[j] == 1 && adjacencyMatrix[j][i] == 1) {
          _drawLineBetweenVertex(canvas, paint, i, j, offsetsOfVertex[i]);
          adjacencyMatrix[j][i] = 0; // TODO: COPY
        } else if(relationsWithThatVertex[j] == 1 ) {
          _drawLineBetweenVertex(canvas, paint, i, j, offsetsOfVertex[i]);          
        }
        textPainter.text = TextSpan(
          text: (i+1).toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )
        );
        textPainter.layout();
        final offsetToText = Offset(offsetsOfVertex[i].dx -10 , offsetsOfVertex[i].dy-10 );
        textPainter.paint(canvas, offsetToText); 
      }
    }
  }

   
  void _calculateOffsetsOfVertex(Size size) {
    final height = size.width * 1.732 / 2;
    final width = size.width;
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

        final offsetDx = distanceBetweenVertexByWidht + distanceBetweenVertexByWidht * offsetCoefficient;
        final offsetDy = height;
        offsetsOfVertex.add(Offset(offsetDx, offsetDy));
      }
    }
  }

  // final _arcRadius = 250.0; 

  void _drawLineBetweenVertex(Canvas canvas, Paint paint, int indexOfVertex, int indexOfRelatedVertex, Offset offsetOfVertex) {
    paint.style = PaintingStyle.stroke;
    Path path = Path(); 
    final sideOfVertex = _getSideOfVertex(indexOfVertex); 
    final sideOfRelatedVertex = _getSideOfVertex(indexOfRelatedVertex);
    final offsetOfRelatedVertex = offsetsOfVertex[indexOfRelatedVertex];
    
    final _arcRadius = (offsetOfVertex + offsetOfRelatedVertex).distance /3;

    
    if(_isVertexOnTheSameSide(indexOfVertex, indexOfRelatedVertex)){
      if((sideOfVertex == 3 && indexOfRelatedVertex - indexOfVertex > 0) || (sideOfRelatedVertex == 3 && indexOfVertex == 0)){
        path.moveTo(offsetOfVertex.dx, offsetOfVertex.dy);
        path.arcToPoint(offsetOfRelatedVertex, radius: Radius.circular(_arcRadius),clockwise: false, largeArc: false);
        drawArcEntryArrow(canvas, offsetOfVertex, offsetOfRelatedVertex, _circleRadius, false, paint);
      }else {
        if(indexOfVertex > indexOfRelatedVertex && sideOfVertex != 3){
          path.moveTo(offsetOfVertex.dx, offsetOfVertex.dy);
          drawArcEntryArrow(canvas, offsetOfVertex, offsetOfRelatedVertex, _circleRadius, false, paint);
          path.arcToPoint(offsetOfRelatedVertex, radius: Radius.circular(_arcRadius), largeArc: true, clockwise:false);
        }else {
          path.moveTo(offsetOfVertex.dx, offsetOfVertex.dy);
          drawArcEntryArrow(canvas, offsetOfVertex, offsetOfRelatedVertex, _circleRadius, true, paint);
          path.arcToPoint(offsetOfRelatedVertex, radius: Radius.circular(_arcRadius),clockwise: true  ,largeArc: true);
          // path.conicTo(offsetOfVertex.dx, offsetOfVertex.dy, offsetOfRelatedVertex.dx, offsetOfRelatedVertex.dy, 1);
        }
      }
      canvas.drawPath(path, paint);
    }else {

      canvas.drawLine(offsetOfVertex, offsetsOfVertex[indexOfRelatedVertex], paint);
      // drawArrow(canvas, offsetOfVertex, offsetOfRelatedVertex, paint);	
    }
    paint.style = PaintingStyle.fill;
  }

  void drawLoop(Canvas canvas, Paint paint, Offset offsetOfVertex) {
    final p1= Offset(offsetOfVertex.dx + 20, offsetOfVertex.dy);
    final p2 = Offset(offsetOfVertex.dx, offsetOfVertex.dy + 20);
    paint.style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.arcToPoint(p2, radius: Radius.circular(20), largeArc: true);
    canvas.drawPath(path, paint);
    paint.style = PaintingStyle.fill;
  }

  bool _isVertexOnTheSameSide(int indexOfVertex, int indexOfRelatedVertex){
    final sideOfVertex = _getSideOfVertex(indexOfVertex);
    final sideOfRelatedVertex = _getSideOfVertex(indexOfRelatedVertex);

    final indexesOfTriangleVertex= [0, maxCountOfVertexOnSide, countOfVertex - 1];
    if(sideOfVertex == sideOfRelatedVertex && (indexOfVertex - indexOfRelatedVertex).abs() > 1 ){
      return true;
    }else if(
      indexesOfTriangleVertex.contains(indexOfVertex) && indexesOfTriangleVertex.contains(indexOfRelatedVertex) && indexOfVertex != indexOfRelatedVertex
    ){
      return true;
    }else {
      return false;
    }
  }  

  void drawArcEntryArrow(
    Canvas canvas,
    Offset arcEnd,
    Offset circleCenter,
    double circleRadius,
    bool clockwise,     
    Paint paint,
  ) {
    final Offset radial = (arcEnd - circleCenter) / (arcEnd - circleCenter).distance;

    Offset tangent;
    if (clockwise) {
      tangent = Offset(radial.dy, -radial.dx);
    } else {
      tangent = Offset(-radial.dy, radial.dx);
    }

    const double arrowHeadLength = 20.0;
    const double arrowAngle = pi / 6;

    final Offset leftDir = Offset(
      tangent.dx * cos(arrowAngle) - tangent.dy * sin(arrowAngle),
      tangent.dx * sin(arrowAngle) + tangent.dy * cos(arrowAngle),
    );
    final Offset rightDir = Offset(
      tangent.dx * cos(-arrowAngle) - tangent.dy * sin(-arrowAngle),
      tangent.dx * sin(-arrowAngle) + tangent.dy * cos(-arrowAngle),
    );

    final point = arcEnd - Offset(circleRadius * tangent.dx, circleRadius * tangent.dy);
    final Offset leftPoint = point - leftDir * arrowHeadLength;
    final Offset rightPoint = point - rightDir * arrowHeadLength;

    canvas.drawLine(point, leftPoint, paint);
    canvas.drawLine(point, rightPoint, paint);
  }




  int _getSideOfVertex(int indexOfVertex){
    if(indexOfVertex <= sidesIndexes[1]){
      return 1;
    }else if(indexOfVertex >= sidesIndexes[1] && indexOfVertex < sidesIndexes[2]){
      return 2;
    }else {
      return 3;
    }
  }

  // void createRelations() { 
  //   // List<Relation> relations = [];
  //   final adjacencyMatrix = []; 
  //   for(int i = 0; i < this.adjacencyMatrix.length; i++) { 
  //     adjacencyMatrix.add([...this.adjacencyMatrix[i]]);
  //   }
  //   for(int i = 0; i < adjacencyMatrix.length; i++) {
  //     for(int j = 0; j < adjacencyMatrix.length; j++){
  //       if(adjacencyMatrix[i][j] == 1) {
  //         if(i == j) {
  //           relations.add(Relation.toItself(offsetsOfVertex[i]));
  //           adjacencyMatrix[i][j] = 0;
  //         }else if(adjacencyMatrix[j][i] == 1 && adjacencyMatrix[i][j] == 1) {
  //           relations.add(Relation(false, true, offsetsOfVertex[i], offsetsOfVertex[j]));
  //           adjacencyMatrix[j][i] = 0;
  //         }else {
  //           relations.add(Relation(false, false, offsetsOfVertex[i], offsetsOfVertex[j]));
  //         }
  //       }
  //     }
  //   }
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// class Relation{
//   bool isRelatedToItself;
//   bool isRelatedToEachOther;
//   Offset firstVertex; 
//   Offset secondVertex;

  
//   Relation(this.isRelatedToItself, this.isRelatedToEachOther, this.firstVertex, this.secondVertex); 

//   // factory Create(Offset firstVertex, Offset secondVertex) {
//     // return Relation._(true, false,  ,firstVertex, secondVertex);
//   // }

//   factory Relation.toItself(Offset vertex) {
//     return Relation(true, true ,vertex, vertex);
//   }

// }