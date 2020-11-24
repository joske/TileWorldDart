import 'dart:collection';
import 'dart:io';

import 'Agent.dart';
import 'GridObject.dart';
import 'Hole.dart';
import 'Location.dart';
import 'Obstacle.dart';
import 'Tile.dart';
import 'dart:math';

class Grid {
  static int COLS = 10;
  static int ROWS = 10;

  Random random = new Random();
  List<Agent> agents = new List();
  List<Tile> tiles = new List();
  List<Hole> holes = new List();
  List<Obstacle> obstacles = new List();
  Map<Location, GridObject> objects = new HashMap();

  Grid(int numAgents, int numTiles, int numHoles, int numObstacles) {
    for (var i = 0; i < numAgents; i++) {
      createAgent(i);
    }
    for (var i = 0; i < numTiles; i++) {
      createTile(i);
    }
    for (var i = 0; i < numHoles; i++) {
      createHole(i);
    }
    for (var i = 0; i < numObstacles; i++) {
      createObstacle(i);
    }
  }

  void start() {
    while (true) {
      for (Agent a in agents) {
        Location orig = a.location;
        a.update();
        Location newLoc = a.location;
        objects[orig] = null;
        objects[newLoc] = a;
      }
      printGrid();
      sleep(Duration(seconds: 1));
    }
  }

  void createAgent(int i) {
    Location l = randomFreeLocation();
    var agent = new Agent(this, i, l);
    this.agents.add(agent);
    objects[l] = agent;
  }

  void createTile(int i) {
    Location l = randomFreeLocation();
    var tile = new Tile(this, i, l);
    tiles.add(tile);
    objects[l] = tile;
  }

  void createHole(int i) {
    Location l = randomFreeLocation();
    var hole = new Hole(this, i, l);
    holes.add(hole);
    objects[l] = hole;
  }

  void createObstacle(int i) {
    Location l = randomFreeLocation();
    var obstacle = new Obstacle(this, i, l);
    obstacles.add(obstacle);
    objects[l] = obstacle;
  }

  Location randomFreeLocation() {
    int col = random.nextInt(COLS);
    int row = random.nextInt(ROWS);
    Location l = new Location(col, row);
    while (!isFree(l)) {
      col = random.nextInt(COLS);
      row = random.nextInt(ROWS);
      l = new Location(col, row);
    }
    return l;
  }

  bool isFree(Location l) {
    return objects[l] == null;
  }

  void printGrid() {
    for (var c = 0; c < COLS - 1; c++) {
      for (var r = 0; r < ROWS - 1; r++) {
        var o = objects[new Location(c, r)];
        if (o != null) {
          if (o is Agent) {
            stdout.write("A");
          } else if (o is Tile) {
            stdout.write("T");
          } else if (o is Hole) {
            stdout.write("H");
          } else {
            stdout.write("#");
          }
        } else {
          stdout.write(".");
        }
      }
      print("");
    }
  }

  Tile getClosestTile(Location location) {
    int closest = 10000000;
    Tile best = null;
    for (Tile t in tiles) {
      if (t.location.distance(location) < closest) {
        best = t;
      }
    }
    return best;
  }

  Hole getClosestHole(Location location) {
    int closest = 10000000;
    Hole best = null;
    for (Hole h in holes) {
      if (h.location.distance(location) < closest) {
        best = h;
      }
    }
    return best;
  }

  void removeTile(Tile tile) {
    tiles.remove(tile);
    objects[tile.location] = null;
    createTile(tile.num);
  }

  void removeHole(Hole hole) {
    holes.remove(hole);
    objects[hole.location] = null;
    createHole(hole.num);
  }
}
