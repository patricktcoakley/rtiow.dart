import 'package:rtiow/hit_record.dart';
import 'package:rtiow/material.dart';
import 'package:rtiow/ray.dart';
import 'package:rtiow/vector3.dart';

class Lambertian implements Material {
  final Color albedo;

  Lambertian(this.albedo);

  @override
  HitRecord scatter(Ray ray, HitRecord hitRecord, Ray scattered) {
    var direction = hitRecord.normal + Vector3.random();
    if (direction.nearZero()) {
      direction = hitRecord.normal;
    }

    scattered
      ..origin = hitRecord.point
      ..direction = direction;

    return hitRecord
      ..attenuation = albedo
      ..wasHit = true;
  }
}
