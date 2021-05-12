import 'Grid.dart';
import 'Location.dart';
import 'dart:collection';

class PathStrategy {
  static List<Direction> shortestPath(Grid grid, Location from, Location to) {
    print("finding path from " + to.toString() + " to " + to.toString());
    List<Location> list = [];
    SplayTreeMap<int, List> queue = new SplayTreeMap();
    list.add(from);
    queue[0] = list;
    while (queue.isNotEmpty) {
      List<Location> path = queue.remove(queue.firstKey()) as List<Location>;
      Location last = path[path.length - 1];
      if (last == to) {
        // path to destination
        return makePath(path);
      }
      generateNext(grid, to, path, queue, Direction.DIR_UP);
      generateNext(grid, to, path, queue, Direction.DIR_DOWN);
      generateNext(grid, to, path, queue, Direction.DIR_LEFT);
      generateNext(grid, to, path, queue, Direction.DIR_RIGHT);
    }
    return [];
  }

  static void generateNext(Grid grid, Location to, List<Location> path, SplayTreeMap<int, List> queue, int direction) {
    print("generateNext " + direction.toString());
    var last = path.last;
    var nextLocation = last.nextLocation(direction);
    if (grid.isValidMove(last, direction) || nextLocation == to) {
      print("considering this direction");
      List<Location> newPath = List.from(path);
      if (!hasLoop(newPath, nextLocation)) {
        newPath.add(nextLocation);
        int cost = newPath.length + nextLocation.distance(to);
        print("no loop, adding #{nextLocation} at cost #{cost} to path: #{newPath}");
        queue[cost] = newPath;
      }
    } else {
      print("invalid direction");
    }
  }

// check for loops
  static bool hasLoop(List<Location> path, Location nextLocation) {
    for (Location l in path) {
      if (l == nextLocation) {
        return true;
      }
    }
    return false;
  }

// make a list of directions from a list of locations
  static List<Direction> makePath(List<Location> list) {
    List<Direction> path = [];
    var last = list.removeAt(0);
    for (Location loc in list) {
      Direction dir = last.getDirection(loc);
      path.add(dir);
      last = loc;
    }
    return path;
  }
}
