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
  group('Testing parseNumValue', () {
    test('Testing basic multiplication', () {
      // Arrange
      const valueObject = '20 * 20';

      // Act
      final result =
          parseNumValue(valueObject: valueObject, variableToValueMapping: {});

      // Assert
      expect(result, 20 * 20);
    });
    test('Testing basic division', () {
      // Arrange
      const valueObject = '20 / 40';

      // Act
      final result =
          parseNumValue(valueObject: valueObject, variableToValueMapping: {});

      // Assert
      expect(result, 20 / 40);
    });
    test('Testing basic subtraction', () {
      // Arrange
      const valueObject = '20 - 40';

      // Act
      final result =
          parseNumValue(valueObject: valueObject, variableToValueMapping: {});

      // Assert
      expect(result, 20 - 40);
    });
    test('Testing basic addition', () {
      // Arrange
      const valueObject = '20 + 40';

      // Act
      final result =
          parseNumValue(valueObject: valueObject, variableToValueMapping: {});

      // Assert
      expect(result, 20 + 40);
    });
    test('Testing mixed operations', () {
      // Arrange
      const valueObject = '20 + 40 - 200 * 40 / 30';

      // Act
      final result =
          parseNumValue(valueObject: valueObject, variableToValueMapping: {});

      // Assert
      expect(
        result.toStringAsPrecision(5),
        (20 + 40 - 200 * 40 / 30).toStringAsPrecision(5),
      );
    });
    test('Testing paranthesis operations', () {
      // Arrange
      const valueObject = '20 + (40 - 200) * 40 / 30';

      // Act
      final result =
          parseNumValue(valueObject: valueObject, variableToValueMapping: {});

      // Assert
      expect(
        result.toStringAsPrecision(5),
        (20 + (40 - 200) * 40 / 30).toStringAsPrecision(5),
      );
    });
    test('Testing nested paranthesis operations', () {
      // Arrange
      const valueObject = '20 + (40 - (200 * 10) - 20) * 40 / 30';

      // Act
      final result =
          parseNumValue(valueObject: valueObject, variableToValueMapping: {});

      // Assert
      expect(
        result.toStringAsPrecision(5),
        (20 + (40 - (200 * 10) - 20) * 40 / 30).toStringAsPrecision(5),
      );
    });
    test('Testing getting value from variable', () {
      // Arrange
      const expected = 4002;
      const variableToValueMapping = {'test1': expected};
      const valueObject = 'test1';

      // Act
      final result = parseNumValue(
        valueObject: valueObject,
        variableToValueMapping: variableToValueMapping,
      );

      // Assert
      expect(
        result,
        expected,
      );
    });
    test('Testing getting value from variable complex', () {
      // Arrange
      const variableValue = 4002;
      const variableToValueMapping = {'test1': variableValue};
      const valueObject = '20 * 40 - (test1 + 10) / 20';

      // Act
      final result = parseNumValue(
        valueObject: valueObject,
        variableToValueMapping: variableToValueMapping,
      );

      // Assert
      expect(
        result.toStringAsPrecision(5),
        (20 * 40 - (variableValue + 10) / 20).toStringAsPrecision(5),
      );
    });
  });
}
