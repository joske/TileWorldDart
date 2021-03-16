class Direction {
  static const int DIR_UP = 1;
  static const int DIR_DOWN = 2;
  static const int DIR_LEFT = 3;
  static const int DIR_RIGHT = 4;

  static Direction up = new Direction(DIR_UP);
  static Direction down = new Direction(DIR_DOWN);
  static Direction left = new Direction(DIR_LEFT);
  static Direction right = new Direction(DIR_RIGHT);

  int dir;
  Direction(this.dir);

  static Direction of(int dir) {
    if (dir == DIR_UP) {
      return up;
    } else if (dir == DIR_DOWN) {
      return down;
    } else if (dir == DIR_LEFT) {
      return left;
    } else {
      return right;
    }
  }
}

class Location {
  int _col;
  int _row;

  Location(this._col, this._row);

  int get col => _col;
  int get row => _row;

  Location nextLocation(int dir) {
    switch (dir) {
      case Direction.DIR_UP:
        return new Location(_col, _row - 1);
      case Direction.DIR_DOWN:
        return new Location(_col, _row + 1);
      case Direction.DIR_LEFT:
        return new Location(_col - 1, _row);
      default:
        return new Location(_col + 1, _row);
    }
  }

  int distance(Location other) {
    return (col - other.col).abs() + (row - other.row).abs();
  }

  bool operator ==(Object other) {
    return other is Location && col == other.col && row == other.row;
  }

  Direction getDirection(Location other) {
    if (row == other.row) {
      if (col == other.col + 1) {
        return Direction.left;
      } else {
        return Direction.right;
      }
    } else {
      if (row == other.row + 1) {
        return Direction.up;
      } else {
        return Direction.down;
      }
    }
  }

  int get hashCode => col.hashCode ^ row.hashCode;

  String toString() {
    return "Location (" + _col.toString() + ", " + _row.toString() + ")";
  }
}
