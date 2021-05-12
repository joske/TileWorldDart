import 'dart:collection';

import 'Grid.dart';
import 'Location.dart';
import 'package:collection/collection.dart';

class AStarStrategy {
  static List<Location> shortestPath(Grid grid, Location from, Location to) {
    print("finding path from " + from.toString() + " to " + to.toString());
    PriorityQueue<Node> openList = HeapPriorityQueue();
    Set<Node> closedList = HashSet();
    Node fromNode = Node(from, 0);
    openList.add(fromNode);
    while (openList.isNotEmpty) {
      Node current = openList.removeFirst();
      if (current.location == to) {
        // goal reached
        return current.path;
      }
      closedList.add(current);
      checkNeighbor(grid, openList, closedList, current, Direction.DIR_UP, from, to);
      checkNeighbor(grid, openList, closedList, current, Direction.DIR_RIGHT, from, to);
      checkNeighbor(grid, openList, closedList, current, Direction.DIR_DOWN, from, to);
      checkNeighbor(grid, openList, closedList, current, Direction.DIR_LEFT, from, to);
    }
    return [];
  }

  static void checkNeighbor(Grid grid, PriorityQueue<Node> openList, Set<Node> closedList, Node current, int direction, Location from, Location to) {
    Location nextLoc = current.location.nextLocation(direction);
    if (nextLoc == to || grid.isValidMove(current.location, direction)) {
      int h = nextLoc.distance(to);
      int g = current.location.distance(from) + 1;
      Node child = new Node(nextLoc, g + h);
      child.path.addAll(current.path);
      child.path.add(nextLoc);
      if (!closedList.contains(child)) {
        List<Node> better = openList.toList().where((e) => e.location == child.location && e.fscore < child.fscore).toList();
        if (better.isEmpty) {
          openList.add(child);
        }
      }
    }
  }
}

class Node implements Comparable<Node> {
  late Location location;
  late int fscore;
  late List<Location> path = [];

  Node(Location location, int fscore) {
    this.location = location;
    this.fscore = fscore;
  }

  int get hashCode => location.hashCode ^ fscore.hashCode;

  bool operator ==(Object other) {
    return other is Node && location == other.location && fscore == other.fscore;
  }

  int compareTo(Node other) {
    return fscore - other.fscore;
  }
}
