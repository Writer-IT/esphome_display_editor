/// Cleans the code line of empty space and drops comments.
String cleanCodeLine(String code) {
  var codeLine = code;

  final commentIndex = codeLine.indexOf('//');
  if (commentIndex >= 0) {
    codeLine = codeLine.replaceRange(commentIndex, codeLine.length, '');
  }

  return codeLine.trim();
}

/// Parse variables with the given signature.
List<Object> parseVariables({
  required String codeLine,
  required String signature,
  Map<String, Object> variableToObjectMapping = const {},
}) {
  final rawVariables = codeLine
      .replaceRange(codeLine.length - 2, codeLine.length, '')
      .replaceRange(0, signature.length, '')
      .split(',')
      .map((variable) => variable.trim())
      .toList();

  final variables = <Object>[];
  for (final rawVariable in rawVariables) {
    if (variableToObjectMapping.keys.contains(rawVariable)) {
      variables.add(variableToObjectMapping[rawVariable]!);
    } else {
      variables.add(rawVariable);
    }
  }

  return variables;
}
