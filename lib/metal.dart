import 'package:rtiow/hit_record.dart';
import 'package:rtiow/material.dart';
import 'package:rtiow/ray.dart';
import 'package:rtiow/vector3.dart';

class Metal implements Material {
  final double fuzz;
  final Color albedo;

  Metal({required this.albedo, double fuzz = 1}) : fuzz = fuzz < 1 ? fuzz : 1;

  @override
  HitRecord scatter(Ray ray, HitRecord hitRecord, Ray scattered) {
    var reflected = Vector3.reflect(ray.direction.normalized, hitRecord.normal);
    scattered
      ..origin = hitRecord.point
      ..direction = reflected + Vector3.randomInUnitSphere().scaled(fuzz);
    return hitRecord
      ..wasHit = Vector3.dot(scattered.direction, hitRecord.normal) > 0
      ..attenuation = albedo;
  }
}
