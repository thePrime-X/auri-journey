import 'package:flutter/material.dart';
import '../../domain/models/coordinate.dart';
import '../../domain/models/level_state.dart';
import 'grid_cell.dart';

class GameGrid extends StatelessWidget {
  final LevelState level;
  final Coordinate auriPosition;
  final bool showTrainingZone;

  const GameGrid({
    super.key,
    required this.level,
    required this.auriPosition,
    this.showTrainingZone = false,
  });

  bool _isInCenterTrainingZone(Coordinate coordinate) {
    return coordinate.row >= 1 &&
        coordinate.row <= 3 &&
        coordinate.col >= 1 &&
        coordinate.col <= 3;
  }

  @override
  Widget build(BuildContext context) {
    final totalCells = level.gridSize * level.gridSize;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: level.gridSize,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final row = index ~/ level.gridSize;
        final col = index % level.gridSize;
        final cellCoordinate = Coordinate(row: row, col: col);

        final isAuri = cellCoordinate == auriPosition;
        final isGoal = cellCoordinate == level.targetPosition;
        final isObstacle = level.obstacles.contains(cellCoordinate);
        final isTrainingZone =
            showTrainingZone && _isInCenterTrainingZone(cellCoordinate);

        return GridCell(
          isAuri: isAuri,
          isGoal: isGoal,
          isObstacle: isObstacle,
          isTrainingZone: isTrainingZone,
        );
      },
    );
  }
}
