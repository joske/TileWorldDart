import 'Grid.dart';
import 'Location.dart';

class GridObject {
  Grid grid;
  int num;
  Location location;
  GridObject(this.grid, this.num, this.location) {
    print("Creating " +
        runtimeType.toString() +
        " " +
        this.num.toString() +
        " at " +
        location.toString());
  }
}
