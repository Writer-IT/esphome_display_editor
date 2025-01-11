import 'dart:collection';
import 'dart:ui';

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

/// Evaluate a number expression and bring it back to the main value.
double evaluateNumberExpressionUnused(
  String expression,
  Map<String, Object> variables,
) {
  final regex = RegExp(r'(\d+\.\d+|\d+|[a-zA-Z_]\w*|[+\-*/()])');
  final tokens = regex.allMatches(expression).map((e) => e.group(0)!).toList();

  final parsedTokens = tokens.map((token) {
    if (variables.containsKey(token)) {
      return variables[token]!.toString();
    }
    return token;
  }).toList();

  final outputQueue = Queue<String>();
  final operatorStack = Queue<String>();
  final precedence = {'+': 1, '-': 1, '*': 2, '/': 2};

  for (final token in parsedTokens) {
    if (double.tryParse(token) != null) {
      outputQueue.addLast(token);
    } else if (['+', '-', '*', '/'].contains(token)) {
      while (operatorStack.isNotEmpty &&
          precedence[operatorStack.last] != null &&
          precedence[operatorStack.last]! >= precedence[token]!) {
        outputQueue.addLast(operatorStack.removeLast());
      }
      operatorStack.addLast(token);
    } else if (token == '(') {
      operatorStack.addLast(token);
    } else if (token == ')') {
      while (operatorStack.isNotEmpty && operatorStack.last != '(') {
        outputQueue.addLast(operatorStack.removeLast());
      }
      operatorStack.removeLast();
    }
  }

  while (operatorStack.isNotEmpty) {
    outputQueue.addLast(operatorStack.removeLast());
  }

  final evaluationStack = Queue<double>();

  while (outputQueue.isNotEmpty) {
    final token = outputQueue.removeFirst();
    if (double.tryParse(token) != null) {
      evaluationStack.addLast(double.parse(token));
    } else if (['+', '-', '*', '/'].contains(token)) {
      final b = evaluationStack.removeLast();
      final a = evaluationStack.removeLast();
      switch (token) {
        case '+':
          evaluationStack.addLast(a + b);
        case '-':
          evaluationStack.addLast(a - b);
        case '*':
          evaluationStack.addLast(a * b);
        case '/':
          evaluationStack.addLast(a / b);
      }
    }
  }

  return evaluationStack.removeLast();
}

/// Checks if a line is a variable reassignment and returns the type.
(bool, Type?) isVariableReassignment(
  String codeLine,
  Map<String, Object> variableToObjectMapping,
) {
  if (codeLine.contains('=')) {
    final assignmentSplit = codeLine.split('=');
    final variablePart = assignmentSplit[0].trim().split(' ');
    if (variablePart.length == 1) {
      final variableName = variablePart[0];
      if (variableToObjectMapping.containsKey(variableName)) {
        return (true, variableToObjectMapping[variableName].runtimeType);
      } else {
        throw StateError('$variableName was not previously instantiated '
            'as expected, please add a type to properly initialize this '
            'variable.');
      }
    }
  }
  return (false, null);
}

/// Parses a textAlign variable to a [TextAlign] enum.
TextAlign parseTextAlign(String textAlignString) {
  const textAlignPrefix = 'TextAlign::';
  if (textAlignString.startsWith(textAlignPrefix)) {
    final alignEnum = textAlignString.replaceFirst(textAlignPrefix, '');
    if (alignEnum.contains('RIGHT')) {
      return TextAlign.right;
    }
    if (alignEnum.contains('LEFT')) {
      return TextAlign.left;
    }
    if (alignEnum.contains('CENTER')) {
      return TextAlign.center;
    }
    return TextAlign.left;
  }
  throw FormatException('This is not a correct TextAlign: $textAlignString');
}
