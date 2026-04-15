enum Direction {
  up,
  right,
  down,
  left,
}

extension DirectionX on Direction {
  Direction get turnLeft {
    switch (this) {
      case Direction.up:
        return Direction.left;
      case Direction.left:
        return Direction.down;
      case Direction.down:
        return Direction.right;
      case Direction.right:
        return Direction.up;
    }
  }

  Direction get turnRight {
    switch (this) {
      case Direction.up:
        return Direction.right;
      case Direction.right:
        return Direction.down;
      case Direction.down:
        return Direction.left;
      case Direction.left:
        return Direction.up;
    }
  }

  String get label {
    switch (this) {
      case Direction.up:
        return 'Up';
      case Direction.right:
        return 'Right';
      case Direction.down:
        return 'Down';
      case Direction.left:
        return 'Left';
    }
  }
}