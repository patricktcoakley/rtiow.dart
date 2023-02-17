import 'package:rtiow/material.dart';
import 'package:rtiow/vector3.dart';

class HitRecord {
  bool isFrontFace;
  bool wasHit;
  double t;
  Material? material;
  Color? attenuation;
  Vector3 point;
  Vector3 normal;

  HitRecord({
    required this.isFrontFace,
    required this.wasHit,
    required this.t,
    this.material,
    this.attenuation,
    required this.point,
    required this.normal,
  });

  factory HitRecord.empty() => HitRecord(
      isFrontFace: false,
      wasHit: false,
      point: Vector3.of(),
      normal: Vector3.of(),
      t: 0);
}
