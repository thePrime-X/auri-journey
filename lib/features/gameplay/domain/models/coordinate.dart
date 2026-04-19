import 'package:flutter/foundation.dart';

@immutable
class Coordinate {
  final int row;
  final int col;

  const Coordinate({required this.row, required this.col});

  Coordinate copyWith({int? row, int? col}) {
    return Coordinate(row: row ?? this.row, col: col ?? this.col);
  }

  Coordinate translate({int rowOffset = 0, int colOffset = 0}) {
    return Coordinate(row: row + rowOffset, col: col + colOffset);
  }

  @override
  String toString() => 'Coordinate(row: $row, col: $col)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coordinate && other.row == row && other.col == col;
  }

  @override
  int get hashCode => Object.hash(row, col);
}
