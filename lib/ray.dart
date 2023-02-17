import 'package:rtiow/vector3.dart';

class Ray {
  Vector3 origin = Vector3();
  Vector3 direction = Vector3();

  Ray({required this.origin, required this.direction});
  Ray.of(this.origin, this.direction);
  Ray.empty();

  Vector3 intersection(double t) => origin + direction.scaled(t);
}
