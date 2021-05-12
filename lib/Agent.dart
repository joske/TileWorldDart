import 'package:tileworld/Astar.dart';

import 'Grid.dart';
import 'GridObject.dart';
import 'Hole.dart';
import 'Location.dart';
import 'Tile.dart';

enum State { IDLE, MOVE_TO_TILE, MOVE_TO_HOLE }

class Agent extends GridObject {
  State state = State.IDLE;
  int score = 0;
  Tile? tile;
  Hole? hole;
  bool hasTile = false;

  Agent(Grid grid, int num, Location location) : super(grid, num, location);

  void update() {
    print(this);
    if (state == State.IDLE) {
      idle();
    } else if (state == State.MOVE_TO_TILE) {
      moveToTile();
    } else {
      moveToHole();
    }
  }

  void idle() {
    tile = null;
    hole = null;
    hasTile = false;
    tile = grid.getClosestTile(location);
    state = State.MOVE_TO_TILE;
  }

  void moveToTile() {
    if (tile?.location == this.location) {
      // we have arrived;
      pickTile();
      return;
    }
    if (grid.objects[tile?.location] != tile) {
      // our tile has gone
      state = State.IDLE;
      return;
    }
    Tile? potentialTile = grid.getClosestTile(this.location);
    if (potentialTile != tile) {
      // this one is closer now
      tile = potentialTile;
    }
    List<Location> path = AStarStrategy.shortestPath(grid, location, tile!.location);
    if (path.isNotEmpty) {
      Location bestDir = path.removeAt(0);
      nextMove(bestDir);
    } else {
      print(toString() + " failed to find a path");
    }
  }

  void moveToHole() {
    if (hole?.location == this.location) {
      // we have arrived;
      dumpTile();
      return;
    }
    if (grid.objects[hole?.location] != hole) {
      // our hole has gone
      state = State.IDLE;
      return;
    }
    Hole? potentialHole = grid.getClosestHole(this.location);
    if (potentialHole != hole) {
      // this one is closer now
      hole = potentialHole;
    }
    List<Location> path = AStarStrategy.shortestPath(grid, location, hole!.location);
    if (path.isNotEmpty) {
      print("got path " + path.toString());
      Location bestDir = path.removeAt(0);
      nextMove(bestDir);
    } else {
      print(toString() + "failed to find a path");
    }
  }

  void nextMove(Location bestDir) {
    this.location = bestDir;
  }

  void pickTile() {
    print(toString() + ": pickTile");
    hasTile = true;
    hole = grid.getClosestHole(this.location);
    state = State.MOVE_TO_HOLE;
    grid.removeTile(this, tile!);
  }

  void dumpTile() {
    print(this.toString() + ": dumpTile");
    grid.removeHole(this, hole!);
    score += tile!.score;
    hasTile = false;
    tile = grid.getClosestTile(location);
    hole = null;
    state = State.MOVE_TO_TILE;
  }

  String toString() {
    return "Agent " +
        this.num.toString() +
        " at " +
        location.toString() +
        " hasTile=" +
        hasTile.toString() +
        " state=" +
        state.toString() +
        " tile=" +
        tile.toString() +
        " hole=" +
        hole.toString();
  }
}
