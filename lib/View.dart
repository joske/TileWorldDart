import 'package:flutter/material.dart';
import 'Grid.dart';
import 'Location.dart';
import 'Agent.dart';
import 'Tile.dart';
import 'Hole.dart';
import "dart:math" show pi;

class View extends CustomPainter {
  late Grid grid;

  View(Grid grid) {
    this.grid = grid;
  }
  @override
  void paint(Canvas canvas, Size size) {
    for (var r = 0; r < Grid.ROWS; r++) {
      for (var c = 0; c < Grid.COLS; c++) {
        var o = grid.objects[new Location(c, r)];
        if (o != null) {
          double x = c * Grid.MAG;
          double y = r * Grid.MAG;
          if (o is Agent) {
            if (o.hasTile) {
              var fill = Paint()
                ..color = Color(getColor(o.num))
                ..style = PaintingStyle.stroke;
              canvas.drawRect(Offset(x, y) & Size(Grid.MAG, Grid.MAG), fill);
              canvas.drawArc(Offset(x, y) & Size(Grid.MAG, Grid.MAG), 0, 2 * pi,
                  false, fill);
              drawText(canvas, o.tile!.score.toString(), x, y, Color(getColor(o.num)));
            } else {
              var fill = Paint()
                ..color = Color(getColor(o.num))
                ..style = PaintingStyle.stroke;
              canvas.drawRect(Offset(x, y) & Size(Grid.MAG, Grid.MAG), fill);
            }
          } else if (o is Tile) {
            var fill = Paint()
              ..color = Color(0xff000000)
              ..style = PaintingStyle.stroke;
            canvas.drawArc(Offset(x, y) & Size(Grid.MAG, Grid.MAG), 0, 2 * pi,
                false, fill);
            drawText(canvas, o.score.toString(), x, y, Colors.black);
          } else if (o is Hole) {
            var fill = Paint()
              ..color = Color(0xff000000)
              ..style = PaintingStyle.fill;
            canvas.drawArc(Offset(x, y) & Size(Grid.MAG, Grid.MAG), 0, 2 * pi,
                false, fill);
          } else {
            var fill = Paint()
              ..color = Color(0xff000000)
              ..style = PaintingStyle.fill;
            canvas.drawRect(Offset(x, y) & Size(Grid.MAG, Grid.MAG), fill);
          }
        }
      }
    }
  }

  void drawText(Canvas canvas, String text, double x, double y, Color color) {
    TextSpan span =
        new TextSpan(style: new TextStyle(color: color), text: text);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(x + Grid.MAG / 4, y));
  }

  int getColor(int num) {
    switch (num) {
      case 0:
        return 0xff0000ff;
      case 1:
        return 0xff00ff00;
      case 2:
        return 0xffff0000;
      case 3:
        return 0xff7f7f00;
      case 4:
        return 0xff007f7f;
      default:
        return 0xff7f007f;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
