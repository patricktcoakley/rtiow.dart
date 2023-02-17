import 'package:rtiow/hit_record.dart';
import 'package:rtiow/material.dart';
import 'package:rtiow/ray.dart';

abstract class Hittable {
  Material? get material;

  HitRecord hit({
    required Ray ray,
    required double tMin,
    required double tMax,
    required HitRecord hitRecord,
    Material? material,
  });
}
