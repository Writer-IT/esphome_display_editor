import 'package:esphome_display_editor/interpreter/display_parser_pass.dart';
import 'package:flutter_test/flutter_test.dart';

late DisplayParserPass displayParserPass;
void main() {
  setUpAll(() {
    displayParserPass = DisplayParserPass();
  });
  group('Testing parseVariables method', () {
    test('Check with valid code line with variables', () {
      // Arrange
      const exampleCode = 'it.circle(20, 75, 10);';
      const signature = 'it.circle(';

      // Act
      final result = displayParserPass.parseVariables(exampleCode, signature);

      // Assert
      expect(result.length, 3);
      expect(result[0], '20');
      expect(result[1], '75');
      expect(result[2], '10');
    });
  });
}
