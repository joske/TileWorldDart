import 'dart:collection';

import 'Grid.dart';
import 'Location.dart';
import 'package:collection/collection.dart';

class AStarStrategy {
  static List<Direction> shortestPath(Grid grid, Location from, Location to) {
    PriorityQueue<Node> openList = HeapPriorityQueue();
    Set<Node> closedList = HashSet();
    Node fromNode = Node(from, null, 0);
    openList.add(fromNode);
    while (openList.isNotEmpty) {
      Node current = openList.removeFirst();
      if (current.location == to) {
        // goal reached
        return makePath(current, fromNode);
      }
      closedList.add(current);
      checkNeighbor(
          grid, openList, closedList, current, Direction.DIR_UP, from, to);
      checkNeighbor(
          grid, openList, closedList, current, Direction.DIR_RIGHT, from, to);
      checkNeighbor(
          grid, openList, closedList, current, Direction.DIR_DOWN, from, to);
      checkNeighbor(
          grid, openList, closedList, current, Direction.DIR_LEFT, from, to);
    }
    return [];
  }

  static void checkNeighbor(
      Grid grid,
      PriorityQueue<Node> openList,
      Set<Node> closedList,
      Node current,
      int direction,
      Location from,
      Location to) {
    Location nextLoc = current.location.nextLocation(direction);
    if (nextLoc == to || grid.isValidMove(current.location, direction)) {
      int h = nextLoc.distance(to);
      int g = current.location.distance(from) + 1;
      Node child = new Node(nextLoc, current, g + h);
      if (!closedList.contains(child)) {
        if (!openList.contains(child)) {
          openList.add(child);
        }
      }
    }
  }

  static makePath(Node end, Node from) {
    List<Direction> reverseMoves = [];
    Node current = end;
    Node? parent = end.parent;
    while (current != from) {
      Direction m = parent!.location.getDirection(current.location);
      reverseMoves.insert(0, m);
      current = parent;
      parent = current.parent;
    }
    return reverseMoves;
  }
}

class Node implements Comparable<Node> {
  late Location location;
  late int fscore;
  late Node? parent;

  Node(Location location, Node? parent, int fscore) {
    this.location = location;
    this.fscore = fscore;
    this.parent = parent;
  }

  int get hashCode => location.hashCode ^ fscore.hashCode;

  bool operator ==(Object other) {
    return other is Node &&
        location == other.location &&
        fscore == other.fscore;
  }

  int compareTo(Node other) {
    return fscore - other.fscore;
  }
}
