enum CommandType {
  moveForward,
  turnLeft,
  turnRight,

  // Future commands
  ifPathClear,
  loop,
  loopUntil,
}

extension CommandTypeX on CommandType {
  String get label {
    switch (this) {
      case CommandType.moveForward:
        return 'Move Forward';
      case CommandType.turnLeft:
        return 'Turn Left';
      case CommandType.turnRight:
        return 'Turn Right';
      case CommandType.ifPathClear:
        return 'If Path Clear';
      case CommandType.loop:
        return 'Loop';
      case CommandType.loopUntil:
        return 'Loop Until';
    }
  }

  bool get isMvpCommand {
    switch (this) {
      case CommandType.moveForward:
      case CommandType.turnLeft:
      case CommandType.turnRight:
        return true;
      case CommandType.ifPathClear:
      case CommandType.loop:
      case CommandType.loopUntil:
        return false;
    }
  }
}
