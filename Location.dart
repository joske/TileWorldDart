class Direction {
  static const int DIR_UP = 1;
  static const int DIR_DOWN = 2;
  static const int DIR_LEFT = 3;
  static const int DIR_RIGHT = 4;

  static Direction UP = new Direction(DIR_UP);
  static Direction DOWN = new Direction(DIR_DOWN);
  static Direction LEFT = new Direction(DIR_LEFT);
  static Direction RIGHT = new Direction(DIR_RIGHT);

  int dir;
  Direction(this.dir) {}

  static Direction of(int dir) {
    if (dir == DIR_UP) {
      return UP;
    } else if (dir == DIR_DOWN) {
      return DOWN;
    } else if (dir == DIR_LEFT) {
      return LEFT;
    } else {
      return RIGHT;
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
        break;
      case Direction.DIR_DOWN:
        return new Location(_col, _row + 1);
        break;
      case Direction.DIR_LEFT:
        return new Location(_col - 1, _row);
        break;
      default:
        return new Location(_col + 1, _row);
        break;
    }
  }

  int distance(Location other) {
    return (col - other.col).abs() + (row - other.row).abs();
  }

  bool operator ==(Object other) {
    return other is Location && col == other.col && row == other.row;
  }

  int get hashCode => col.hashCode ^ row.hashCode;

  String toString() {
    return "Location (" + _col.toString() + ", " + _row.toString() + ")";
  }
}
