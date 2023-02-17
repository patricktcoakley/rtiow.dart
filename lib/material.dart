import 'package:rtiow/hit_record.dart';
import 'package:rtiow/ray.dart';

abstract class Material {
  HitRecord scatter(Ray ray, HitRecord hitRecord, Ray scattered);
}
