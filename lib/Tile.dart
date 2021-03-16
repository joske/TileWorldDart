import 'Grid.dart';
import 'GridObject.dart';
import 'Location.dart';

class Tile extends GridObject {
  int score = 0;
  Tile(Grid grid, int num, Location location, int score)
      : super(grid, num, location) {
    this.score = score;
  }

  String toString() {
    return "Tile " + this.num.toString() + " at " + location.toString();
  }
}
