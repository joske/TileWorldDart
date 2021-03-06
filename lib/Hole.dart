import 'Grid.dart';
import 'GridObject.dart';
import 'Location.dart';

class Hole extends GridObject {
  Hole(Grid grid, int num, Location location) : super(grid, num, location);

  String toString() {
    return "Hole " + this.num.toString() + " at " + location.toString();
  }
}
