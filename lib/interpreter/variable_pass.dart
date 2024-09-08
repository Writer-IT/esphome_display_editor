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

  static const _intSignature = 'int';
  static const _doubleSignature = 'double';
  static const _stringSignature = 'std::string';
  static const _mapSignature = 'std::map<';
  static const _autoSignature = 'auto';

  /// Process the lambda code in a display section.
  (Map<String, Object>, List<String>) processDisplayCode(
    List<String> codeLines,
  ) {
    final fixedCodeLines = <String>[];
    for (var codeLine in codeLines) {
      codeLine = cleanCodeLine(codeLine);
      switch (codeLine) {
        // Alright we're in auto mode, so we'll have to figure things out.
        case final autoVar when autoVar.startsWith(_autoSignature):
          if (codeLine.contains('Color')) {
            _storeVariable(
              variableType: VariableTypes.color,
              codeLine: codeLine,
            );
          }
        case final integer when integer.startsWith(_intSignature):
          _storeVariable(
            variableType: VariableTypes.int,
            codeLine: codeLine,
          );
        case final dbl when dbl.startsWith(_doubleSignature):
          _storeVariable(
            variableType: VariableTypes.double,
            codeLine: codeLine,
          );
        case final str when str.startsWith(_stringSignature):
          _storeVariable(
            variableType: VariableTypes.double,
            codeLine: codeLine,
          );
        case final mapping when mapping.startsWith(_mapSignature):
          throw UnimplementedError(
            'Map variables are not supported as of now.',
          );
      }
      fixedCodeLines.add(codeLine);
    }
    return (variableValueMapping, codeLines);
  }

  (String, String) _extractNameAndValueString(String codeLine) {
    final splittedLine = codeLine.split('=');

    final variableName = splittedLine[0].split(' ').last;
    final valueString = splittedLine[1];

    return (variableName, valueString);
  }

  void _storeVariable({
    required VariableTypes variableType,
    required String codeLine,
  }) {
    final (variableName, valueString) = _extractNameAndValueString(codeLine);

    late Object valueObject;

    switch (variableType) {
      case VariableTypes.int:
        valueObject = int.parse(valueString);
      case VariableTypes.double:
        valueObject = double.parse(valueString);
      case VariableTypes.string:
        valueObject = valueString;
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
          0,
        );
      case VariableTypes.map:
        throw UnimplementedError("Can't translate map variables yet");
    }

    final mappedName = 'var:$variableName$variableCounter';
    variableCounter += 1;
    variableNameMapping[variableName] = mappedName;
    variableValueMapping[mappedName] = valueObject;
  }
}
