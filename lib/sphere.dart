import 'dart:math';

import 'package:rtiow/hit_record.dart';
import 'package:rtiow/hittable.dart';
import 'package:rtiow/material.dart';
import 'package:rtiow/math.dart';
import 'package:rtiow/ray.dart';
import 'package:rtiow/vector3.dart';

class Sphere implements Hittable {
  final double radius;
  final Vector3 center;
  @override
  final Material? material;

  const Sphere({required this.radius, required this.center, this.material});

  const Sphere.of(this.radius, this.center, this.material);

  @override
  HitRecord hit({
    required Ray ray,
    required double tMin,
    required double tMax,
    required HitRecord hitRecord,
    Material? material,
  }) {
    hitRecord.wasHit = false;

    var originCenter = ray.origin - center;
    var a = Vector3.dot(ray.direction, ray.direction);
    var halfB = Vector3.dot(originCenter, ray.direction);
    var c = originCenter.lengthSquared - radius * radius;
    var discriminant = halfB * halfB - a * c;

    if (discriminant < 0) {
      return hitRecord;
    }

    var sqrtD = sqrt(discriminant);
    var root = (-halfB - sqrtD) / a;
    if (root.outsideRange(min: tMin, max: tMax)) {
      root = (-halfB + sqrtD) / a;
      if (root.outsideRange(min: tMin, max: tMax)) {
        return hitRecord;
      }
    }

    hitRecord
      ..t = root
      ..point = ray.intersection(hitRecord.t);

    var outwardNormal = (hitRecord.point - center) / radius;
    var isFrontFace = Vector3.dot(ray.direction, outwardNormal) < 0;
    var normal = isFrontFace ? outwardNormal : -outwardNormal;

    return hitRecord
      ..isFrontFace = isFrontFace
      ..normal = normal
      ..material = material
      ..wasHit = true;
  }
}
