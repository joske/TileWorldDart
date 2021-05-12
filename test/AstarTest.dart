import 'package:test/test.dart';
import 'package:tileworld/Astar.dart';
import 'package:tileworld/Grid.dart';
import 'package:tileworld/Location.dart';

void main() {
  test('path via astar', () {
    Grid grid = Grid(0, 0);
    Location from = Location(0, 0);
    Location to = Location(10, 10);
    var path = AStarStrategy.shortestPath(grid, from, to);
    assert(path.isNotEmpty);
    assert(path.length == 20);
  });
}
