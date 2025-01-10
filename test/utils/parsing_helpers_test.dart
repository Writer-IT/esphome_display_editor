import 'package:esphome_display_editor/utils/parsing_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing findClosures', () {
    const openPattern = '(';
    const closePattern = ')';
    test('Testing basic paranthesis String', () {
      // Arrange
      const input = '(20 + 5)';
      const expected = (0, 7);

      // Act
      final result = findClosures(
        openPattern: openPattern,
        closePattern: closePattern,
        input: input,
      );

      // Assert
      expect(result, expected);
    });
    test('Testing nested paranthesis String', () {
      // Arrange
      const input = '(20 + (10 + 5))';
      const expected = (0, 14);

      // Act
      final result = findClosures(
        openPattern: openPattern,
        closePattern: closePattern,
        input: input,
      );

      // Assert
      expect(result, expected);
    });
    test('Testing non-closed paranthesis String', () {
      // Arrange
      const input = '(20 + (10 + 5)';
      const expected = null;

      // Act
      final result = findClosures(
        openPattern: openPattern,
        closePattern: closePattern,
        input: input,
      );

      // Assert
      expect(result, expected);
    });
    test('Testing embedded paranthesis String', () {
      // Arrange
      const input = '4 * (20 + (10 + 5)) - 20';
      const expected = (4, 18);

      // Act
      final result = findClosures(
        openPattern: openPattern,
        closePattern: closePattern,
        input: input,
      );

      // Assert
      expect(result, expected);
    });
  });
}
