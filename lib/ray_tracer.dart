import 'package:rtiow/hit_record.dart';
import 'package:rtiow/hittable.dart';
import 'package:rtiow/ray.dart';
import 'package:rtiow/vector3.dart';

Color rayColor(Ray ray, Hittable world, int depth) {
  if (depth <= 0) {
    return Color();
  }
  var hitRecord = HitRecord.empty();
  hitRecord = world.hit(
      ray: ray, tMin: 0.01, tMax: double.infinity, hitRecord: hitRecord);

  if (hitRecord.wasHit) {
    var scattered = Ray.empty();
    if (hitRecord.material!.scatter(ray, hitRecord, scattered).wasHit) {
      return Vector3.mul(
          rayColor(scattered, world, depth - 1), hitRecord.attenuation!);
    }

    return Vector3();
  }

  var unitDirection = ray.direction.normalized;
  var t = 0.5 * (unitDirection.y + 1);
  return Color.all(1).scaled(1.0 - t) + Color.of(0.5, 0.7, 1.0).scaled(t);
}
