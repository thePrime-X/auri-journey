import 'package:flutter_test/flutter_test.dart';
import 'package:auri_app/features/gameplay/domain/models/coordinate.dart';

void main() {
  group('Coordinate', () {
    test('creates a coordinate with correct row and col', () {
      const coordinate = Coordinate(row: 2, col: 3);

      expect(coordinate.row, 2);
      expect(coordinate.col, 3);
    });

    test('copyWith returns a new coordinate with updated row only', () {
      const original = Coordinate(row: 2, col: 3);

      final updated = original.copyWith(row: 5);

      expect(updated.row, 5);
      expect(updated.col, 3);
    });

    test('copyWith returns a new coordinate with updated col only', () {
      const original = Coordinate(row: 2, col: 3);

      final updated = original.copyWith(col: 7);

      expect(updated.row, 2);
      expect(updated.col, 7);
    });

    test('copyWith returns identical values when no parameters are given', () {
      const original = Coordinate(row: 2, col: 3);

      final copied = original.copyWith();

      expect(copied.row, 2);
      expect(copied.col, 3);
      expect(copied, original);
    });

    test('translate updates row and col using offsets', () {
      const original = Coordinate(row: 2, col: 3);

      final translated = original.translate(rowOffset: 1, colOffset: -2);

      expect(translated.row, 3);
      expect(translated.col, 1);
    });

    test('translate works with default zero offsets', () {
      const original = Coordinate(row: 2, col: 3);

      final translated = original.translate();

      expect(translated.row, 2);
      expect(translated.col, 3);
      expect(translated, original);
    });

    test('supports equality for same row and col', () {
      const a = Coordinate(row: 1, col: 4);
      const b = Coordinate(row: 1, col: 4);

      expect(a, equals(b));
    });

    test('does not consider different coordinates equal', () {
      const a = Coordinate(row: 1, col: 4);
      const b = Coordinate(row: 2, col: 4);

      expect(a, isNot(equals(b)));
    });

    test('has same hashCode for equal coordinates', () {
      const a = Coordinate(row: 5, col: 6);
      const b = Coordinate(row: 5, col: 6);

      expect(a.hashCode, b.hashCode);
    });

    test('toString returns readable coordinate format', () {
      const coordinate = Coordinate(row: 3, col: 8);

      expect(coordinate.toString(), 'Coordinate(row: 3, col: 8)');
    });
  });
}
