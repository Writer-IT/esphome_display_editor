/// Tries to find a closure like paranthesis and returns their indices.
///
/// So for example this String would return:
/// "(20 + (30 + 10))" => (0, 15)
///
/// If no closure is found it returns null
(int, int)? findClosures({
  required String openPattern,
  required String closePattern,
  required String input,
}) {
  if (openPattern.length != 1) {
    throw ArgumentError('$openPattern has to be a single character');
  }
  if (closePattern.length != 1) {
    throw ArgumentError('$closePattern has to be a single character');
  }
  final stack = <int>[];
  for (var i = 0; i < input.length; i++) {
    final character = input[i];
    if (character == openPattern) {
      stack.add(i);
    }
    if (character == closePattern) {
      final begin = stack.removeLast();
      if (stack.isEmpty) {
        return (begin, i);
      }
    }
  }
  return null;
}

/// Parse a num value and returns it's value.
double parseNumValue({
  required Object valueObject,
  required Map<String, Object> variableToValueMapping,
}) {
  final valueString = valueObject.toString().trim();
  final naiveResult = double.tryParse(valueString);
  if (naiveResult != null) {
    return naiveResult;
  }

  final closures =
      findClosures(openPattern: '(', closePattern: ')', input: valueString);
  if (closures != null) {
    final (start, end) = closures;
    var collapsedValueString = parseNumValue(
      valueObject: valueString.substring(start + 1, end),
      variableToValueMapping: variableToValueMapping,
    ).toString();
    if (start > 0) {
      collapsedValueString =
          valueString.substring(0, start - 1) + collapsedValueString;
    }
    if (end < valueString.length) {
      collapsedValueString =
          collapsedValueString + valueString.substring(end + 1);
    }
    return parseNumValue(
      valueObject: collapsedValueString,
      variableToValueMapping: variableToValueMapping,
    );
  }

  final addSplit = valueString.split('+');
  if (addSplit.length > 1) {
    return addSplit.fold(
      0,
      (collector, element) =>
          collector +
          parseNumValue(
            valueObject: element,
            variableToValueMapping: variableToValueMapping,
          ),
    );
  }
  final subSplit = valueString.split('-');
  if (subSplit.length > 1) {
    return subSplit.skip(1).fold(
          parseNumValue(
            valueObject: subSplit.first,
            variableToValueMapping: variableToValueMapping,
          ),
          (collector, element) =>
              collector -
              parseNumValue(
                valueObject: element,
                variableToValueMapping: variableToValueMapping,
              ),
        );
  }
  final mulSplit = valueString.split('*');
  if (mulSplit.length > 1) {
    return mulSplit.fold(
      1,
      (collector, element) =>
          collector *
          parseNumValue(
            valueObject: element,
            variableToValueMapping: variableToValueMapping,
          ),
    );
  }
  final divSplit = valueString.split('/');
  // Handling the edge case of encounter 1 + -10,
  // where the split will be [],[10]
  if (divSplit.length == 1 && divSplit[0] == '') {
    return 0;
  }
  if (divSplit.length > 1) {
    return divSplit.skip(1).fold(
          parseNumValue(
            valueObject: divSplit.first,
            variableToValueMapping: variableToValueMapping,
          ),
          (collector, element) =>
              collector /
              parseNumValue(
                valueObject: element,
                variableToValueMapping: variableToValueMapping,
              ),
        );
  }
  if (variableToValueMapping.containsKey(valueString)) {
    final value = variableToValueMapping[valueString];
    if (value != null && value.runtimeType == int) {
      return (value as int).toDouble();
    } else {
      return value! as double;
    }
  }
  throw ArgumentError(
    'Provided value cannot be parsed as a number: $valueString',
  );
}
