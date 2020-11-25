import 'Grid.dart';
import 'GridObject.dart';
import 'Location.dart';

class Tile extends GridObject {
  Tile(Grid grid, int num, Location location) : super(grid, num, location);

  String toString() {
    return "Tile " + this.num.toString() + " at " + location.toString();
  }
}
