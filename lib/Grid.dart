import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

import 'Agent.dart';
import 'GridObject.dart';
import 'Hole.dart';
import 'Location.dart';
import 'Obstacle.dart';
import 'Tile.dart';
import 'dart:math';

class Grid with ChangeNotifier {
  static const int COLS = 40;
  static const int ROWS = 40;
  static const int SLEEP = 200;
  static const double MAG = 20;

  Random random = new Random();
  List<Agent> agents = [];
  List<Tile> tiles = [];
  List<Hole> holes = [];
  List<Obstacle> obstacles = [];
  Map<Location, GridObject?> objects = new HashMap();
  int numTiles = 0;

  Grid(int numAgents, int numTiles) {
    this.numTiles = numTiles;
    for (var i = 0; i < numAgents; i++) {
      createAgent(i);
    }
    for (var i = 0; i < numTiles; i++) {
      createTile(i);
    }
    for (var i = 0; i < numTiles; i++) {
      createHole(i);
    }
    for (var i = 0; i < numTiles; i++) {
      createObstacle(i);
    }
  }

  void update() {
    for (Agent a in agents) {
      Location orig = a.location;
      a.update();
      Location newLoc = a.location;
      objects[orig] = null;
      objects[newLoc] = a;
      // printGrid();
      notifyListeners();
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
    int score = random.nextInt(6) + 1;
    var tile = new Tile(this, i, l, score);
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

  bool isValidMove(Location location, int dir) {
    if (dir == Direction.DIR_UP)
      return location.row > 0 && isFree(location.nextLocation(dir));
    else if (dir == Direction.DIR_DOWN)
      return location.row < ROWS - 1 && isFree(location.nextLocation(dir));
    else if (dir == Direction.DIR_LEFT)
      return location.col > 0 && isFree(location.nextLocation(dir));
    else
      return location.col < COLS - 1 && isFree(location.nextLocation(dir));
  }

  void printGrid() {
    for (var r = 0; r < ROWS; r++) {
      for (var c = 0; c < COLS; c++) {
        var o = objects[new Location(c, r)];
        if (o != null) {
          if (o is Agent) {
            if ((o).hasTile) {
              stdout.write("Å");
            } else {
              stdout.write("A");
            }
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
    for (Agent a in agents) {
      print("Agent " + a.num.toString() + ": " + a.score.toString());
    }
  }

  Tile? getClosestTile(Location location) {
    int closest = 10000000;
    Tile? best;
    for (Tile t in tiles) {
      var distance = t.location.distance(location);
      if (distance < closest) {
        closest = distance;
        best = t;
      }
    }
    return best;
  }

  Hole? getClosestHole(Location location) {
    int closest = 10000000;
    Hole? best;
    for (Hole h in holes) {
      var distance = h.location.distance(location);
      if (distance < closest) {
        closest = distance;
        best = h;
      }
    }
    return best;
  }

  void removeTile(Agent agent, Tile tile) {
    tiles.remove(tile);
    objects[tile.location] = agent;
    createTile(tile.num);
    assert(tiles.length == numTiles);
  }

  void removeHole(Agent agent, Hole hole) {
    holes.remove(hole);
    objects[hole.location] = agent;
    createHole(hole.num);
    assert(holes.length == numTiles);
  }
}
