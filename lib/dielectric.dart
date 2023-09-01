import 'dart:math';

import 'package:rtiow/hit_record.dart';
import 'package:rtiow/material.dart';
import 'package:rtiow/math.dart';
import 'package:rtiow/ray.dart';
import 'package:rtiow/vector3.dart';

class Dielectric implements Material {
  final double ir;

  Dielectric(this.ir);

  @override
  HitRecord scatter(Ray ray, HitRecord hitRecord, Ray scattered) {
    hitRecord.attenuation = Color.all(1);
    var refractionRatio = hitRecord.isFrontFace ? (1.0 / ir) : ir;
    var direction = ray.direction.normalized;
    var cosTheta = min(Vector3.dot(-direction, hitRecord.normal), 1.0);
    var sinTheta = sqrt(1.0 - cosTheta * cosTheta);
    var cantRefract = refractionRatio * sinTheta > 1.0;
    var refraction =
        cantRefract || _reflectance(cosTheta, refractionRatio) > randomDouble()
            ? Vector3.reflect(direction, hitRecord.normal)
            : Vector3.refract(direction, hitRecord.normal, refractionRatio);

    scattered
      ..origin = hitRecord.point
      ..direction = refraction;

    return hitRecord..wasHit = true;
  }

  double _reflectance(double cos, double refIdx) {
    var r0 = (1 - refIdx) / (1 + refIdx);
    r0 *= r0;
    return r0 + (1 - r0) * pow((1 - cos), 5);
  }
}
