import 'package:rtiow/hit_record.dart';
import 'package:rtiow/hittable.dart';
import 'package:rtiow/material.dart';
import 'package:rtiow/ray.dart';

class HittableList implements Hittable {
  final List<Hittable> _buffer;

  const HittableList([List<Hittable> hittables = const []])
      : _buffer = hittables;

  void add(Hittable hittable) => _buffer.add(hittable);
  void addAll(Iterable<Hittable> iterable) => _buffer.addAll(iterable);

  @override
  HitRecord hit({
    required Ray ray,
    required double tMin,
    required double tMax,
    required HitRecord hitRecord,
    Material? material,
  }) {
    var temp = HitRecord.empty();
    var closestSoFar = tMax;
    var didHitSomething = false;
    for (var hittable in _buffer) {
      temp = hittable.hit(
        ray: ray,
        tMin: tMin,
        tMax: closestSoFar,
        hitRecord: HitRecord.empty(),
        material: material,
      );
      if (temp.wasHit) {
        closestSoFar = temp.t;
        hitRecord.isFrontFace = temp.isFrontFace;
        hitRecord.material = hittable.material;
        hitRecord.normal = temp.normal;
        hitRecord.point = temp.point;
        hitRecord.t = temp.t;
        didHitSomething = true;
      }
    }
    hitRecord.wasHit = didHitSomething;
    return hitRecord;
  }

  @override
  Material? get material => _buffer[0].material;
}
