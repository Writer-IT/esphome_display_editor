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
List<String> parseVariables(String codeLine, String signature) => codeLine
    .replaceRange(codeLine.length - 2, codeLine.length, '')
    .replaceRange(0, signature.length, '')
    .split(',')
    .map((variable) => variable.trim())
    .toList();
