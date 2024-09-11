import 'package:esphome_display_editor/interpreter/interpreter_utilities.dart';
import 'package:esphome_display_editor/interpreter/variable_types.dart';
import 'package:flutter/material.dart';

/// Collects variable names and replaces occurances with their reference to the
/// object.
class VariablePass {
  /// Variable counter stored per VariablePass, to make sure we all names are
  /// unique.
  int variableCounter = 0;

  /// Mapping between variables and their temporary name.
  final variableNameMapping = <String, String>{};

  /// Mapping between variable unique names and their values.
  final variableValueMapping = <String, Object>{};

  /// Signature where you can see if something is a variable in the returned
  /// line.
  static const variableSignature = '|var|:';

  static const _intSignature = 'int';
  static const _doubleSignature = 'double';
  static const _stringSignature = 'std::string';
  static const _mapSignature = 'std::map<';
  static const _autoSignature = 'auto';

  /// Process the lambda code in a display section.
  /// Returns the mapping from temp variables to objects, as well as a trimmed
  /// version of the code with all variable assignments and empty lines removed.
  (Map<String, Object>, List<String>) processDisplayCode(
    List<String> codeLines,
  ) {
    final fixedCodeLines = <String>[];
    for (var codeLine in codeLines) {
      codeLine = cleanCodeLine(codeLine);
      switch (codeLine) {
        case final emptyLine when emptyLine.isEmpty:
          break;

        case final variableLine when variableLine.contains('='):
          extractVariables(variableLine);

        default:
          fixedCodeLines.add(replaceVariables(codeLine));
      }
    }
    return (variableValueMapping, fixedCodeLines);
  }

  /// Replaces variables in the provided [codeLine] that are available to the
  /// [VariablePass]. Returns the codeLine where all variables are replaced with
  /// their temporary counter part, the temporary variable is a key for the
  /// corresponding Object.
  String replaceVariables(String codeLine) {
    var result = codeLine;
    for (final variable in variableNameMapping.keys) {
      // Make sure we match the exact variable name, so no issue with 'person'
      // and 'person_1'.
      final variablePattern = RegExp(r'\b' + RegExp.escape(variable) + r'\b');
      if (result.contains(variablePattern)) {
        result =
            result.replaceAll(variablePattern, variableNameMapping[variable]!);
      }
    }
    return result;
  }

  /// Extract a variable from the codeLine, maps it to a temporary variable and
  /// stores the corresponding object under the temporary variable.
  void extractVariables(String codeLine) {
    switch (codeLine) {
      // Alright we're in auto mode, so we'll have to figure things out.
      case final autoVar when autoVar.startsWith(_autoSignature):
        if (codeLine.contains('Color')) {
          storeVariable(
            variableType: VariableTypes.color,
            codeLine: codeLine,
          );
        }
      case final integer when integer.startsWith(_intSignature):
        storeVariable(
          variableType: VariableTypes.int,
          codeLine: codeLine,
        );
      case final dbl when dbl.startsWith(_doubleSignature):
        storeVariable(
          variableType: VariableTypes.double,
          codeLine: codeLine,
        );
      case final str when str.startsWith(_stringSignature):
        storeVariable(
          variableType: VariableTypes.double,
          codeLine: codeLine,
        );
      case final mapping when mapping.startsWith(_mapSignature):
        throw UnimplementedError(
          'Map variables are not supported as of now.',
        );
      default:
        // TODO: Implement reassigning a variable?
        throw UnimplementedError('''
        Whatever this line does, we can't hanlde it yet :(
        You can open an issue on https://github.com/Writer-IT/esphome_display_editor if it doesn't exist yet.
        Please provided the offending code line and a minimal reproducible example if possible.

        The offending line: $codeLine
        ''');
    }
  }

  /// Extracts the name and the value of a variable assignment code line.
  (String, String) extractNameAndValueString(String codeLine) {
    final splittedLine = codeLine.split('=');

    final variableNameList = splittedLine[0].split(' ')
      ..removeWhere((string) => string.trim().isEmpty);
    final variableName = variableNameList.last;
    final valueString = splittedLine[1];

    return (variableName, valueString);
  }

  /// Stores the variable under the temporary name of the variable.
  void storeVariable({
    required VariableTypes variableType,
    required String codeLine,
  }) {
    final (variableName, valueString) = extractNameAndValueString(codeLine);

    late Object valueObject;

    switch (variableType) {
      case VariableTypes.int:
        valueObject = int.parse(valueString.replaceAll(';', ''));
      case VariableTypes.double:
        valueObject = double.parse(valueString.replaceAll(';', ''));
      case VariableTypes.string:
        // TODO this is relatively naive, we only handle str a = "something";
        valueObject =
            valueString.replaceAll('";', '').replaceFirst('"', '').trim();
      case VariableTypes.color:
        final colorValues = valueString
            .trim()
            .replaceFirst('Color(', '')
            .replaceFirst(');', '')
            .split(',');
        valueObject = Color.fromRGBO(
          int.parse(colorValues[0]),
          int.parse(colorValues[1]),
          int.parse(colorValues[2]),
          1,
        );
      case VariableTypes.map:
        throw UnimplementedError("Can't translate map variables yet");
    }

    final mappedName = '$variableSignature$variableName$variableCounter';
    variableCounter += 1;
    variableNameMapping[variableName] = mappedName;
    variableValueMapping[mappedName] = valueObject;
  }
}
