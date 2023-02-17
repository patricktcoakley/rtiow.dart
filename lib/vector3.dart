import 'dart:math';

import 'package:rtiow/math.dart';

typedef Color = Vector3;

class Vector3 {
  final double x;
  final double y;
  final double z;

  double get r => x;

  double get g => y;

  double get b => z;

  double get lengthSquared => x * x + y * y + z * z;

  double get length => sqrt(lengthSquared);

  Vector3 get normalized => this / length;

  const Vector3({this.x = 0, this.y = 0, this.z = 0});
  const Vector3.of([this.x = 0, this.y = 0, this.z = 0]);

  factory Vector3.rgb({double r = 0, double g = 0, double b = 0}) =>
      Vector3.of(r, g, b);

  factory Vector3.all(double t) => Vector3.of(t, t, t);

  factory Vector3.random() =>
      Vector3.of(randomDouble(), randomDouble(), randomDouble());

  factory Vector3.randomInside({required double min, required double max}) =>
      Vector3.of(
        randomDoubleInside(min: min, max: max),
        randomDoubleInside(min: min, max: max),
        randomDoubleInside(min: min, max: max),
      );

  factory Vector3.randomInUnitSphere() {
    while (true) {
      var p = Vector3.randomInside(min: -1.0, max: 1.0);
      if (p.lengthSquared >= 1) {
        continue;
      }

      return p;
    }
  }

  factory Vector3.randomInHemisphere(Vector3 normal) {
    var unitSphere = Vector3.randomInUnitSphere();
    if (dot(unitSphere, normal).isNegative) {
      return -unitSphere;
    }

    return unitSphere;
  }

  factory Vector3.randomInUnitDisk() {
    while (true) {
      var p = Vector3(
          x: randomDoubleInside(min: -1, max: 1),
          y: randomDoubleInside(min: -1, max: 1));
      if (p.lengthSquared >= 1) {
        continue;
      }

      return p;
    }
  }

  Vector3 operator -() => Vector3.of(-x, -y, -z);

  Vector3 operator +(Vector3 rhs) =>
      Vector3.of(x + rhs.x, y + rhs.y, z + rhs.z);

  Vector3 operator -(Vector3 rhs) =>
      Vector3.of(x - rhs.x, y - rhs.y, z - rhs.z);

  Vector3 operator *(double t) => Vector3.of(x * t, y * t, z * t);

  Vector3 operator /(double t) => this * (1.0 / t);

  Vector3 scaled(double t) => this * t;

  bool nearZero() {
    const s = 1e-8;
    return (x.abs() < s && y.abs() < s && z.abs() < s);
  }

  static Vector3 reflect(Vector3 lhs, Vector3 rhs) =>
      lhs - rhs.scaled(2 * dot(lhs, rhs));

  static Vector3 refract(Vector3 uv, Vector3 n, double etaOverEta) {
    var cosTheta = min(dot(-uv, n), 1.0);
    var rOutPerp = (uv + n.scaled(cosTheta)) * etaOverEta;
    var rOutParallel = n * -sqrt((1.0 - rOutPerp.lengthSquared).abs());
    return rOutPerp + rOutParallel;
  }

  static double dot(Vector3 lhs, Vector3 rhs) =>
      lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z;

  static Vector3 cross(Vector3 lhs, Vector3 rhs) => Vector3.of(
      lhs.y * rhs.z - lhs.z * rhs.y,
      lhs.z * rhs.x - lhs.x * rhs.z,
      lhs.x * rhs.y - lhs.y * rhs.x);

  static Vector3 mul(Vector3 lhs, Vector3 rhs) =>
      Vector3.of(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z);
}
