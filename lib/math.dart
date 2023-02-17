import 'dart:math';

final _rand = Random(DateTime.now().millisecondsSinceEpoch);

extension Shared on double {
  bool insideRange(
          {double min = double.negativeInfinity,
          double max = double.infinity}) =>
      this >= min && this <= max;

  bool outsideRange(
          {double min = double.negativeInfinity,
          double max = double.infinity}) =>
      !insideRange(min: min, max: max);

  double get radians => this * pi / 180.0;
}

double randomDouble() => _rand.nextDouble();
double randomDoubleInside({required double min, required double max}) =>
    min + (max - min) * randomDouble();
