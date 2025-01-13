import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void expectPaints(Paint actual, Paint expected) {
  expect(actual.color.value, expected.color.value);
  expect(actual.style, expected.style);
}
