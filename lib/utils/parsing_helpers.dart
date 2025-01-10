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
