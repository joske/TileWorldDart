import 'Grid.dart';
import 'GridObject.dart';
import 'Hole.dart';
import 'Location.dart';
import 'Tile.dart';

enum State { IDLE, MOVE_TO_TILE, MOVE_TO_HOLE }

class Agent extends GridObject {
  State state = State.IDLE;
  int score = 0;
  Tile tile = null;
  Hole hole = null;
  bool hasTile = false;

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
    if (tile.location == this.location) {
      // we have arrived;
      pickTile();
      return;
    }
    if (grid.objects[tile.location] != tile) {
      // our tile has gone
      state = State.IDLE;
      return;
    }
    Tile potentialTile = grid.getClosestTile(this.location);
    if (potentialTile != tile) {
      // this one is closer now
      tile = potentialTile;
    }
    Direction bestDir = findBestMove(tile.location);
    nextMove(bestDir);
  }

  void moveToHole() {
    if (hole.location == this.location) {
      // we have arrived;
      dumpTile();
      return;
    }
    if (grid.objects[hole.location] != hole) {
      // our hole has gone
      state = State.IDLE;
      return;
    }
    Hole potentialHole = grid.getClosestHole(this.location);
    if (potentialHole != hole) {
      // this one is closer now
      hole = potentialHole;
    }
    Direction bestDir = findBestMove(hole.location);
    nextMove(bestDir);
  }

  Direction findBestMove(Location to) {
    int r = grid.random.nextInt(100);
    if (r < 20) {
      print(toString() + " random move");
      int dir = grid.random.nextInt(4); // exclusive end: 0..3
      while (!grid.isValidMove(location, dir)) {
        dir = grid.random.nextInt(4); // exclusive end: 0..3
      }
      return Direction.of(dir);
    }
    int bestDir = 0;
    int minDist = 1000000;
    for (var dir = 1; dir <= 4; dir++) {
      print(toString() + " considering " + dir.toString());
      Location nextLocation = location.nextLocation(dir);
      if (nextLocation == to) {
        print("next location leads to destination");
        bestDir = dir;
        // arrived
        break;
      }
      if (grid.isValidMove(location, dir)) {
        print("is valid");
        int dist = nextLocation.distance(to);
        if (dist < minDist) {
          print(" and closer to destination: " + dist.toString());
          minDist = dist;
          bestDir = dir;
        } else {
          print(" but further from destination: " + dist.toString());
        }
      } else {
        print("is not valid");
      }
    }
    return Direction.of(bestDir);
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
    grid.removeTile(tile);
  }

  void dumpTile() {
    print(this.toString() + ": dumpTile");
    grid.removeHole(hole);
    score += tile.score;
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
