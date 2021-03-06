import 'Grid.dart';
import 'GridObject.dart';
import 'Hole.dart';
import 'Location.dart';
import 'PathStrategy.dart';
import 'Tile.dart';

enum State { IDLE, MOVE_TO_TILE, MOVE_TO_HOLE }

class Agent extends GridObject {
  State state = State.IDLE;
  int score = 0;
  Tile? tile;
  Hole? hole;
  bool hasTile = false;
  List<Direction> path = [];

  Agent(Grid grid, int num, Location location) : super(grid, num, location);

  void update() {
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
    if (path.isEmpty) {
      path = PathStrategy.shortestPath(grid, location, tile!.location);
    }
    if (path.isNotEmpty) {
      Direction bestDir = path.removeAt(0);
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
    if (path.isEmpty) {
      path = PathStrategy.shortestPath(grid, location, hole!.location);
    }
    if (path.isNotEmpty) {
      Direction bestDir = path.removeAt(0);
      nextMove(bestDir);
    } else {
      print(toString() + "failed to find a path");
    }
  }

  void nextMove(Direction bestDir) {
    print(toString() + " move: " + bestDir.dir.toString());
    this.location = this.location.nextLocation(bestDir.dir);
  }

  void pickTile() {
    print(toString() + ": pickTile");
    hasTile = true;
    hole = grid.getClosestHole(this.location);
    state = State.MOVE_TO_HOLE;
    grid.removeTile(tile!);
  }

  void dumpTile() {
    print(this.toString() + ": dumpTile");
    grid.removeHole(hole!);
    score += tile!.score;
    tile = null;
    hole = null;
    hasTile = false;
    state = State.IDLE;
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
